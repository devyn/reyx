# mount an external resource
@output.puts "Mounting #{@args[1]} on device:#{@args[0]} . . ."
Reyx::FS.device_table[@args.shift] = @args.shift

