# update-init script
Reyx::FS.conf_open 'sys-data:init.yml' do |y|
    case @args.shift.downcase
    when 'add'
        @output.puts "%% \e[33mAdding #{@args[1]} to #{@args[0]} . . .\e[0m"
        y[@args.shift] << {@args.shift => @args.shift}
    when 'remove'
        @output.puts "%% \e[33mRemoving #{@args[1]} from #{@args[0]} . . .\e[0m"
        y[@args.shift].reject! {|i| i.keys[0] == @args.shift}
    else
        @output.puts "error: No such action."
    end
end
