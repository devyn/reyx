require 'fileutils'
require 'ext/Z4'
module Reyx
    module Applications; extend self
        def unpack(f)
            z4f = Z4File.new(f)
            Dir.chdir(Reyx::FS.host_dir) { loop { z4f.extract_next } }
        rescue Exception
            return
        end
        def install_package(p)
            Reyx::FS.open(p) {|f| unpack f}
        end
        def install_host_package(p)
            File.open(p) {|f| unpack f}
        end
        def uninstall(sn)
            FileUtils.rm_r Reyx::FS.translate_path("application:#{sn}")
        end
        def list
            Dir.entries(Reyx::FS.translate_path("application")) - %w(. ..)
        end
        def format_info(sn)
            rs = ""
            Reyx::FS.conf_open "application:#{sn}:app.yml" do |y|
                y.each do |k,v|
                    rs << "#{k}:#{v.is_a?(String) ? v.gsub(/^/, "\t") : v.inspect}\n"
                end
            end
            rs
        end
    end
end
