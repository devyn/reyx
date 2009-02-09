require 'fileutils'
require 'yaml'
require 'open-uri'
module Reyx
    # file system functions (Reyx only)
    module FS; extend self
        attr_accessor :host_dir, :device_table
        @host_dir = File.expand_path(ENV['REYX_HOST_DIR']||"~/.reyx")
        @device_table = {}
        def open(p, mode='r', &blk)
            FileUtils.mkdir_p File.dirname(translate_path(p)) unless ['r', 'r+'].include? mode
            File.open(translate_path(p), mode, &blk)
        end
        def conf_open(p, &blk)
            y = open(p) {|f| YAML.load(f) } rescue {}
            yield y
            open(p,'w') {|f| YAML.dump(y, f)}
            true
        end
        def net_open(p, &blk)
            o = Kernel.open(translate_path(p))
            block_given? ? yield(o) : o
        end
        def list(p)
            Dir.entries(translate_path(p)) - %w(. ..)
        end
        def parse_path(p)
            a = p.split(':')
            r = {}
            case r[:service] = a.shift.downcase
            when 'app-data'
                r[:user] = a.shift
                r[:application] = a.shift
                r[:file] = a.join('/')
            when 'application'
                r[:application] = a.shift
                r[:file] = a.join('/')
            when 'temp'
                r[:application] = a.shift
                r[:file] = a.join('/')
            when 'device'
                r[:device_name] = a.shift
                r[:file] = a
            when 'sys-data'
                r[:file] = a.join('/')
            when 'net'
                q = a.shift.split('~')
                r[:host] = q.shift
                r[:port] = q.shift.to_i if q.first
                r[:path] = a.join('/')
            when 'user-file'
                r[:user] = a.shift
                r[:file] = a.join('/')
            else
                r[:data] = a
            end
            r
        end
        def translate_path(p)
            pp = parse_path p
            pt = [@host_dir]
            case pp[:service]
            when 'app-data'
                pt.push 'Users', pp[:user], pp[:application], pp[:file]
            when 'application'
                pt.push 'Applications', pp[:application], pp[:file]
            when 'temp'
                pt.push 'Temporary Files', pp[:application], pp[:file]
            when 'device'
                pt = [@device_table[pp[:device_name]], pp[:file]]
            when 'sys-data'
                pt.push 'System Files', pp[:file]
            when 'net'
                pt = ["http://#{pp[:host]}#{":#{pp[:port]}" if pp[:port]}/#{pp[:path]}"]
            when 'user-file'
                pt.push 'Users', pp[:user], 'Personal Files', pp[:file]
            else
                raise ArgumentError, 'path not translateable'
            end
            File.join pt
        end
    end
end
