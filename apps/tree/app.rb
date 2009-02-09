case @args.shift
    # TODO: more actions
when '-l', '-list'
    Reyx::FS.list(@args.shift||@path).each do |e|
        # TODO: something more interesting in the future...
        @output.puts e
    end
end

