desc 'run on setup'
task :default => [:clean, :build_packages, :vm_dir]
desc 'clean the application packages'
task :clean do
    rm_f FileList["apps/*.rxp"]
end
desc 'build the application packages'
task :build_packages do
    require 'ext/Z4'
    FileList["apps/*"].each do |e|
        next unless File.directory? e
        puts "BUILDRXP #{e}.rxp"
        f = File.open("#{e}.rxp", 'w')
        z4f = Z4File.create(f)
        FileList["#{e}/**"].each do |fe|
            z4f.write_file fe, :name => "Applications/#{fe.sub(/^apps\//, '')}"
        end
        f.close
    end
end
desc 'create the virtual machine directory'
task :vm_dir do
    require 'reyx/fs'
    require 'reyx/applications'
    require 'reyx/skel'
    rm_rf Reyx::FS.host_dir
    Reyx.skel
end
desc 'install a host package'
task :install_host_package do
    require 'reyx/fs'
    require 'reyx/applications'
    print "Package to install: "
    Reyx::Applications.install_host_package $stdin.gets.chomp
end
desc 'install all packages'
task :install_packages => :build_packages do
    require 'reyx/fs'
    require 'reyx/applications'
    FileList["apps/*.rxp"].each do |a|
        puts "INSTALL #{a}"
        Reyx::Applications.install_host_package a
    end
end
