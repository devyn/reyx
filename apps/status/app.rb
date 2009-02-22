# Show information about the system.
@output.puts "\e[1m# Mounted Devices\e[0m"
Reyx::FS.device_table.each do |path, mto|
    @output.puts "\e[32mdevice:#{path}\e[0m => \e[31m#{mto}\e[0m"
end
@output.puts "\e[1m# Users logged on\e[0m"
Reyx::Daemon.connections.each do |c|
    @output.puts "\e[36mSocket:\e[1m#{c[0].object_id.to_s(16)}\e[0m | \e[34m#{c[1]['user'] or "\e[31mnot logged in"}\e[0m"
end

