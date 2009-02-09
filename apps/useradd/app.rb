# add a user
Reyx::FS.conf_open "sys-data:users.yml" do |y|
    @output.puts "$ $ $   PROMPT-MASK: Password:    $ $ $"
    y[@args.shift] = {'password' => @input.gets.chomp}
end
