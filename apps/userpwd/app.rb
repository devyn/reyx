Reyx::FS.conf_open "sys-data:users.yml" do |y|
    @output.puts "$ $ $   PROMPT-MASK: Password:    $ $ $"
    y[@user]['password'] = @input.gets.chomp
end
