
Reyx::FS.open(@args[0],'w') do |f|
    ln = nil
    lpc = proc { @output.puts("$ $ $   READLINE   $ $ $"); (ln = @input.gets) == "EOF\n" }
    until lpc.call
        f.puts ln
    end
end if Reyx::FS.permitted?(@user,@args[0])

