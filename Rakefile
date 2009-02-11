require 'ext/Z4'
task :default => [:clean, :build_packages]
task :clean do
    rm_f FileList["apps/*.rxp"]
end
task :build_packages do
    FileList["apps/*"].each do |e|
        next unless File.directory? e
        puts "BUILDRXP #{e}.rxp"
        f = File.open("#{e}.rxp", 'w')
        z4f = Z4File.create(f)
        FileList["#{e}/**"].each do |fe|
            z4f.write_file fe, :name => "Applications/#{e.sub(/^apps\//, '')}"
        end
        f.close
    end
end

