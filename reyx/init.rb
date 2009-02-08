require 'yaml'
module Reyx
    module Init; extend self
        def run ty
            puts "%% \e[1mInit:\e[0m running \e[32m@#{ty}\e[0m"
            Reyx::FS.conf_open "sys-data:init.yml" do |tt|
                tt[ty].each do |tsw|
                    tsw.each do |ts, des|
                        puts "%%\t\e[33m#{des}\e[0m"
                        Reyx::Shell.run(ts, $stdout, $stdin, 'admin')
                    end
                end
            end
            puts "%% \e[1mInit:\e[0m completed \e[32m@#{ty}\e[0m"
            true
        end
        def up; run 'up'; end
        def down; run 'down'; end
    end
end

