# for now, UNIX hosts only.
`mount`.split("\n").collect{|i|i.scan(/^\/dev\/([sh]d[a-z][0-9]) on ([^ ]+)/)}.reject{|i|i.empty?}.each do |i|
    Reyx::FS.device_table[i[0][0]] = i[0][1]
    @output.puts "\e[32mdevice:#{i[0][0]}\e[0m => \e[31m#{i[0][1]}\e[0m" unless @args.include? '-s'
end
