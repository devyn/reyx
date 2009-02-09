module Reyx
    def self.skel
        Reyx::FS.conf_open "sys-data:init.yml" do |y|
            y['up'] = []
            y['down'] = []
        end
        Reyx::FS.conf_open "sys-data:users.yml" do |y|
            y['admin'] = {'password' => 'admin'}
        end
        Reyx::FS.conf_open "application:appman:app.yml" do |y|
            y['short-name'] = "appman"
            y['full-name'] = "Application Manager"
            y['users-allowed'] = ['admin']
            y['usage'] = <<-EOF
appman install <path-to-package> # installs an application
appman uninstall <short-name>    # uninstalls an application
appman list                      # list of all applications
appman info <short-name>         # shows information on an application
EOF
        end
        Reyx::FS.open "application:appman:app.rb", 'w' do |f|
            f.write <<-EOF
case @args.shift
when 'install'
    Reyx::Applications.install_package @args.shift
when 'uninstall'
    Reyx::Applications.uninstall @args.shift
when 'list'
    Reyx::Applications.list.each do |i|
        @output.puts "* \#{i}"
    end
when 'info'
    @output.puts Reyx::Applications.format_info @args.shift
end
EOF
        end
        Dir.glob("apps/*.rxp").each do |p|
            Reyx::Applications.install_host_package p
        end
    end
end
