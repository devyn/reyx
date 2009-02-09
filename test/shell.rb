#!/usr/bin/env ruby
require 'rubygems'
require 'socket'
require 'highline/import'

sock = TCPSocket.new(ENV['REYX_HOST']||'localhost', 44698)
un = ask("\e[33mUser name?\e[0m ").chomp
pw = ask("\e[33mPassword?\e[0m  ") {|x|x.echo="*"}.chomp
sock.puts "@ #{un}:#{pw}"
abort("error: Invalid User Name or Password") unless sock.gets == "@ @ @   CONFIRMED   @ @ @\n"
loop do
    case cmd = ask("\e[34m#{un}\e[0m $ ") {|x| x.readline=true}.chomp
    when 'exit', 'quit'
        sock.puts ">.<"
        sock.close
        break
    when /^chpath /
        sock.puts "-> #{cmd.sub(/^chpath /, '')}"
    else
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
