require 'socket'
module Reyx
    # Reyx's connection daemon
    module Daemon; extend self
        @connections = []
        @thread = nil
        attr_reader :thread
        def start
            Reyx::Init.up
            @thread = Thread.start do
                @server = TCPServer.new(ENV['REYX_HOST']||'localhost', 44698) # Reyx Daemon Port
                loop do
                    Thread.start(@server.accept) do |sock|
                        sockinfo = {}
                        @connections << [sock, sockinfo]
                        puts "\e[36mSocket:\e[1m#{sock.object_id.abs.to_s(16)}\e[0m connected."
                        catch :loop_break_one do
                            while cmd = sock.gets
                                process_cmd(sock, sockinfo, cmd) or throw(:loop_break_one)
                            end
                        end
                        sock.close
                        @connections.delete [sock, sockinfo]
                        puts "\e[36mSocket:\e[1m#{sock.object_id.abs.to_s(16)}\e[0m disconnected."
                    end
                end
            end
        end
        def stop
            @connections.each {|c| c[0].close }
            @thread.kill
            @server.close
            @thread = nil
            @connections = []
            @server = nil
            Reyx::Init.down
        end
        def process_cmd sock, sockinfo, cmd
            case cmd
            when /^\@ /
                if Reyx::Auth.user_auth_correct? *cmd.chomp.sub(/^\@ /, '').split(":")[0..1]
                    sockinfo['user'] = cmd.chomp.sub(/^\@ /, '').split(":")[0]
                    sock.puts "@ @ @   CONFIRMED   @ @ @"
                    puts "\e[36mSocket:\e[1m#{sock.object_id.abs.to_s(16)}\e[0m logged in as #{sockinfo['user']}"
                else
                    sock.puts "@ @ @   DENIED   @ @ @"
                    puts "\e[36mSocket:\e[1m#{sock.object_id.abs.to_s(16)}\e[0m hacking attempt foiled! (incorrect username/password)"
                end
            when /^\$ /
                puts "\e[36mSocket:\e[1m#{sock.object_id.abs.to_s(16)}\e[0m executing shell command: #{cmd.chomp.sub(/^\$ /, '')}"
                Reyx::Shell.run(cmd.chomp.sub(/^\$ /, ''), sock, sock, sockinfo['user'], sockinfo['path']) rescue sock.puts("error: #{$!.message}")
                sock.puts "$ $ $   NEXT   $ $ $"
            when /^\? /
                puts "\e[36mSocket:\e[1m#{sock.object_id.abs.to_s(16)}\e[0m requesting information: #{cmd.chomp.sub(/^\? /, '')}"
                sock.puts sockinfo[cmd.chomp.sub(/^\? /, '')]
            when /^\-\> /
                puts "\e[36mSocket:\e[1m#{sock.object_id.abs.to_s(16)}\e[0m changing PATH: #{cmd.chomp.sub(/^\-\> /, '')}"
                sockinfo['path'] = cmd.chomp.sub(/^\-\> /, '')
            when ">.<\n", ">.<\r\n"
                puts "\e[36mSocket:\e[1m#{sock.object_id.abs.to_s(16)}\e[0m says goodbye!"
                return false
            else
                puts "\e[36mSocket:\e[1m#{sock.object_id.abs.to_s(16)}\e[0m sent invalid command: #{cmd.inspect}"
                sock.puts "! ! !   INVALID   ! ! !"
            end
            true
        end
    end
end

