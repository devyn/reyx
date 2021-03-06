inf = {}
Reyx::FS.conf_open("application:#{@args.shift}:app.yml") {|y| inf = y}
allowed = inf['users-allowed'] ? inf['users-allowed'].include?(@user) : true
@output.puts "\e[1m#{inf['full-name'] or inf['short-name']}\e[0m"
@output.puts "\tYou are #{allowed ? "\e[32mallowed\e[0m" : "\e[31mnot allowed\e[0m"} to run this application."
@output.puts
@output.puts "\tUsage:"
@output.puts "\e[33m" << inf['usage'].gsub(/^/, "\t") << "\e[0m"