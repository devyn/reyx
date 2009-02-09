#!/usr/bin/env ruby
# Initialize Reyx VM
require 'rubygems'
Dir.glob("reyx/*.rb"){|r|require r}
puts "%% Creating skeleton . . ."
Reyx.skel

