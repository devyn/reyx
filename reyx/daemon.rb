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
                @server = TCPServer.new('localhost', 44698) # Reyx Daemon Port
                loop do
                    Thread.start(@server.accept) do |sock|
                        sockinfo = {}
                        @connections << [sock, sockinfo]
                        puts "Socket:#{sock.object_id.abs.to_s(16)} connected."
                        catch :loop_break_one do
                            while cmd = sock.gets
                                process_cmd(sock, sockinfo, cmd) or throw(:loop_break_one)
                            end
                        end
                        sock.close
                        @connections.delete [sock, sockinfo]
                        puts "Socket:#{sock.object_id.abs.to_s(16)} disconnected."
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
                puts "Socket:#{sock.object_id.abs.to_s(16)} logging in."
                # for now, automatically approve
                sockinfo['user'] = cmd.chomp.sub(/^\@ /, '').split(":")[0]
                sock.puts "@ @ @   CONFIRMED   @ @ @"
            when /^\$ /
                puts "Socket:#{sock.object_id.abs.to_s(16)} executing shell command: #{cmd.chomp.sub(/^\$ /, '')}"
                # Reyx::Shell.run(cmd.sub(/^\$ /, ''), sock, sockinfo['user'])
                sock.puts "$ $ $   NEXT   $ $ $"
            when /^\? /
                puts "Socket:#{sock.object_id.abs.to_s(16)} requesting information: #{cmd.chomp.sub(/^\? /, '')}"
                sock.puts sockinfo[cmd.chomp.sub(/^\? /, '')]
            when ">.<\n", ">.<\r\n"
                puts "Socket:#{sock.object_id.abs.to_s(16)} says goodbye!"
                return false
            else
                puts "Socket:#{sock.object_id.abs.to_s(16)} sent invalid command: #{cmd.inspect}"
                sock.puts "! ! !   INVALID   ! ! !"
            end
            true
        end
    end
end

