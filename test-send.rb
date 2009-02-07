require 'socket'

sock = TCPSocket.new('localhost', 44698)
sock.puts "@ " << ARGV.shift
abort("Can't login.") unless sock.gets == "@ @ @   CONFIRMED   @ @ @\n"
sock.puts "$ " << ARGV.shift
until (ln = sock.gets) == "$ $ $   NEXT   $ $ $\n"
    puts sock.gets.sub(/^\> /, '')
end
sock.puts ">.<" # say goodbye!
sock.close
