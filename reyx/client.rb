require 'socket'
require 'highline/import'
module Reyx
    module Client; extend self
        class EndSession < Exception; end
        class FatalError < Exception; end
        class MinorError < Exception; end
        def header str, color="30;44"
            print "\e[s\e[H\e[#{color}m\e[K #{str}\e[0m\n\e[u"
        end
        def connect_to_server host=nil, port=nil
            @sock = TCPSocket.new(host||ENV['REYX_HOST']||'localhost', (port||44698).to_i) rescue raise(FatalError, "can not connect to server")
        end
        def q_ask q
            ask("\e[33m#{q}\e[0m ").chomp
        end
        def q_ask_mask q
            ask("\e[33m#{q}\e[0m ") {|x|x.echo="*"}.chomp
        end
        def logon
            header "<<< Reyx: Please Login >>>", "30;43"
            user = q_ask      "User:    "
            pass = q_ask_mask "Password:"
            @sock.puts "@ #{user}:#{pass}"
            raise FatalError, "invalid user or password" unless @sock.gets == "@ @ @   CONFIRMED   @ @ @\n"
            @user = user
        end
        def clear_screen
            puts "\e[2J\e[H"
        end
        def run_next
            header "<<< Reyx: #@user >>>"
            case cmd = ask("\e[34m#{@user}\e[0m $ ") {|x| x.readline=true}.chomp
            when 'exit', 'quit'
                @sock.puts ">.<"
                @sock.close
                raise EndSession
            when /^chpath /
                @sock.puts "-> #{cmd.sub(/^chpath /, '')}"
            else
                header "<<< Reyx: #@user (#{cmd}) >>>", "30;42"
                @sock.puts "$ #{cmd}"
                until (ln = @sock.gets) == "$ $ $   NEXT   $ $ $\n"
                    if ln =~ /^\$ \$ \$   PROMPT: (.*)   \$ \$ \$$/
                        @sock.puts q_ask($1)
                    elsif ln =~ /^\$ \$ \$   PROMPT-MASK: (.*)   \$ \$ \$$/
                        @sock.puts q_ask_mask($1)
                    elsif ln =~ /^error: /
                        puts "\e[31m#{ln.chomp}\e[0m"
                    else
                        puts ln
                    end
                end
            end
        end
    end
end
