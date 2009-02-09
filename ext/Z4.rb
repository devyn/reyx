### Z4 descriptive archive format ###
    #### the successor of Z3 ####
         ##### ~devyn! #####

require 'json'
require 'fileutils'
require 'ostruct'

class Z4File
    class EndOfStreamError < Exception; end
    class InvalidFileError < Exception; end
    class FileNotFoundError < Exception; end
    attr_reader :archive_metadata
    def self.create(output_stream=$stdout, archive_metadata={}, input_stream=$stdin, status_stream=nil)
        z4f = allocate
        z4f.instance_variable_set '@is', input_stream
        z4f.instance_variable_set '@os', output_stream
        z4f.instance_variable_set '@ss', status_stream
        output_stream.write "DCZ4"
        output_stream.puts JSON.generate(archive_metadata)
        z4f
    end
    def initialize(input_stream=$stdin, output_stream=$stdout, status_stream=nil)
        @is, @os, @ss = input_stream, output_stream, status_stream
        raise InvalidFileError, 'not a Z4 file' unless @is.read(4) == "DCZ4"
        @archive_metadata = get_metadata
    end
    def get_metadata
        OpenStruct.new(JSON.parse(@is.gets.chomp))
    end
    def entries
        opos = @is.pos
        ents = []
        loop do
            ents << get_metadata
            @is.pos += ents[-1].size
        end
    rescue Exception
        @is.pos = opos
        return ents
    end
    def seek_to(fname)
        opos = @is.pos
        loop do
            bfpos = @is.pos
            md = get_metadata
            if md.name == fname
                @is.pos = bfpos
                return md
            else
                @is.pos += md.size
                @is.readline
            end
        end
    rescue Exception
        @is.pos = opos
        raise FileNotFoundError, 'file not found'
    end
    def extract_next
        raise EndOfStreamError, 'end of stream!' if @is.eof?
        info = get_metadata
        @ss.puts info.name if @ss
        FileUtils.mkdir_p(File.dirname(File.join('.', info.name)))
        File.open File.join('.', info.name), 'w' do |f|
            info.size.times do
                f.putc @is.getc
            end
        end
        File.chmod(info.mode, File.join('.', info.name))
        @is.readline
        return info
    end
    def write_file(fname, additional_metadata={})
        info = OpenStruct.new
        stt = File.stat(fname)
        info.mode = stt.mode
        info.user = stt.uid
        info.group = stt.gid
        info.name = fname
        info.send(:table).update(additional_metadata)
        info.size = stt.size
        @os.puts JSON.generate(info.send(:table))
        File.open(fname) do |f|
            until f.eof?
                @os.putc f.getc
            end
        end
        @os.puts
    end
    def close
        @is.close
        @os.close
        @ss.close
    end
end

if __FILE__ == $0
    case ARGV.shift
    when 'create'
        z4f = Z4File.create
        for ent in ARGV
            z4f.write_file ent
        end
    when 'unpack'
        z4f = Z4File.new
        z4f.instance_variable_set '@ss', $stderr
        kg = true
        while kg
            begin
                z4f.extract_next
            rescue Z4File::EndOfStreamError
                kg = false
            end
        end
    end
end
