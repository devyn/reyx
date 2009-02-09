# Show information about the system.
@output.puts "\e[1m# Mounted Devices\e[0m"
Reyx::FS.device_table.each do |path, mto|
    @output.puts "\e[32mdevice:#{path}\e[0m => \e[31m#{mto}\e[0m"
end

