module Reyx
    module Shell; extend self
        def run(cmd, output, input, as_user, path="sys-data:")
            # TODO: implement user permissions
            args = parse_args cmd
            app  = args.shift
            return if app.empty?
            raise ArgumentError, 'no such command' unless File.exists? Reyx::FS.translate_path("application:#{app}:app.rb")
            o    = Object.new
            o    .instance_variable_set("@args", args)
            o    .instance_variable_set("@output", output)
            o    .instance_variable_set("@input", input)
            o    .instance_variable_set("@user", as_user)
            o    .instance_variable_set("@path", path)
            ua = nil
            Reyx::FS.conf_open("application:#{app}:app.yml") {|y| ua = y['users-allowed']}
            unless ua.nil? or ua.include?(as_user)
                raise ArgumentError, "command not allowed for #{as_user}"
                return
            end
            Reyx::FS.open("application:#{app}:app.rb") {|f| o.instance_eval f.read}
        end
        def parse_args(s)
            a = [""]
            ins = false
            esc = false
            s.each_char do |c|
                if c == '"'
                    if esc
                        a[-1] << c
                        esc = false
                    elsif ins
                        ins = false
                    else
                        ins = true
                    end
                elsif c == ' '
                    if esc or ins
                        a[-1] << c
                        esc = false
                    else
                        a << ""
                    end
                elsif c == '\\'
                    if esc
                        a[-1] << '\\'
                        esc = false
                    else
                        esc = true
                    end
                else
                    a[-1] << c
                end
            end
            a
        end
    end
end
