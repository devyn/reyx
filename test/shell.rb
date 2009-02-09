#!/usr/bin/env ruby
require 'rubygems'
require 'socket'
require 'highline/import'

def w_header(s)
    print "\e[s\e[H\e[30;44m\e[K ::: Reyx @ #{ENV['REYX_HOST']||'localhost'} (#{s}) :::\e[0m\n\e[u"
end
puts "\e[2J\e[H"
puts

sock = TCPSocket.new(ENV['REYX_HOST']||'localhost', 44698) rescue abort("\e[2J\e[Herror: Can not connect to server")
w_header 'login'
un = ask("\e[33mUser name?\e[0m ").chomp
pw = ask("\e[33mPassword?\e[0m  ") {|x|x.echo="*"}.chomp
sock.puts "@ #{un}:#{pw}"
abort("\e[2J\e[Herror: Invalid User Name or Password") unless sock.gets == "@ @ @   CONFIRMED   @ @ @\n"
loop do
    w_header 'shell'
    case cmd = ask("\e[34m#{un}\e[0m $ ") {|x| x.readline=true}.chomp
    when 'exit', 'quit'
        sock.puts ">.<"
        sock.close
        break
    when /^chpath /
        sock.puts "-> #{cmd.sub(/^chpath /, '')}"
    else
        w_header cmd
        sock.puts "$ #{cmd}"
        until (ln = sock.gets) == "$ $ $   NEXT   $ $ $\n"
            if ln =~ /^\$ \$ \$   PROMPT: (.*)   \$ \$ \$$/
                sock.puts ask($1)
            elsif ln =~ /^\$ \$ \$   PROMPT-MASK: (.*)   \$ \$ \$$/
                sock.puts ask($1) {|x| x.echo="*"}
            else
                puts ln
            end
        end
    end
end
print "\e[2J\e[H"
