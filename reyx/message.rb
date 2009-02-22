module Reyx
    class Message
        attr_accessor :msg, :from
        def initialize msg, from, to
            @msg, @from = msg, from
            @to = Reyx::Daemon.connections.select{|c|c[0].object_id == to.to_i(16)}.first
        end
        def to; @to[0].object_id.to_s(16); end
        def write_msg
            @to[0].puts "\e[1m\e[32m%%[\e[0m\e[1m#{@from}\e[32m]\t\e[0m#{@msg}"
        end
        # call this!
        def add_to_queue
            @to[1]['queued_messages'] ||= []
            @to[1]['queued_messages'] << self
        end
    end
end
