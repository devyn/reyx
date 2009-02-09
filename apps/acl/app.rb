Reyx::FS.conf_open "application:#{@args.shift}:app.yml" do |y|
    case @args.shift
    when /allow/i
        y['users-allowed'] = [] unless y['users-allowed']
        y['users-allowed'] << @args.shift
    when /deny/i
        y['users-allowed'] = [] unless y['users-allowed']
        y['users-allowed'].delete @args.shift
    else
        @output.puts "error: No such action."
    end
end
