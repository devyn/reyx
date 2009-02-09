Reyx::FS.conf_open "sys-data:users.yml" do |y|
    y.delete @args.shift
end
