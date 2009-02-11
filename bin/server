#!/usr/bin/env ruby
require 'rubygems'
Dir.glob("reyx/*.rb") {|r| require r}
trap("INT") { Reyx::Daemon.stop }
trap("TERM"){ Reyx::Daemon.stop }
Reyx::Daemon.start
Reyx::Daemon.thread.join
