case @args.shift
when 'install'
    Reyx::Applications.install_package @args.shift
when 'uninstall'
    Reyx::Applications.uninstall @args.shift
when 'list'
    Reyx::Applications.list.each do |i|
        @output.puts "* #{i}"
    end
when 'info'
    @output.puts Reyx::Applications.format_info @args.shift
end
