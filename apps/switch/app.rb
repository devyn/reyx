# switch users for one command
u = @args.shift
upw = nil
Reyx::FS.conf_open "sys-data:users.yml" do |y|
    upw = y[u]['password']
end
@output.puts "$ $ $   PROMPT-MASK: Password:    $ $ $"
if upw == @input.gets.chomp
    Reyx::Shell.run(@args.shift, @output, @input, u, @path)
else
    @output.puts "error: invalid user name or password."
end
