require 'yaml'
module Reyx
    module Init; extend self
        def run ty
            tt = Reyx::FS.open("sys-data:init.yml") {|f| YAML.load(f)[ty] }
            puts "%% Init: running @#{ty}"
            tt.each do |tsw|
                tsw.each do |ts, des|
                    puts "%%\t#{des}"
                    # Reyx::Shell.run(ts, $stdout, 'admin')
                end
            end
            puts "%% Init: completed @#{ty}"
            true
        end
        def up; run 'up'; end
        def down; run 'down'; end
    end
end

