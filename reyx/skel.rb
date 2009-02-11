module Reyx
    def self.skel
        puts "install sys-data:init.yml"
        Reyx::FS.conf_open "sys-data:init.yml" do |y|
            y['up'] = []
            y['down'] = []
        end
        puts "install sys-data:users.yml"
        Reyx::FS.conf_open "sys-data:users.yml" do |y|
            y['admin'] = {'password' => 'admin'}
        end
        Dir.glob("apps/*.rxp").each do |p|
            puts "install application:#{File.basename(p).split('.').first}"
            Reyx::Applications.install_host_package p
        end
    end
end
