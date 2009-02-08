#!/usr/bin/env ruby
require 'reyx/fs'
require 'reyx/daemon'
require 'reyx/init'
require 'reyx/auth'
require 'reyx/shell'
trap("INT") { Reyx::Daemon.stop }
trap("TERM"){ Reyx::Daemon.stop }
Reyx::Daemon.start
Reyx::Daemon.thread.join
