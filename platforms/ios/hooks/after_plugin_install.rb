#!/usr/bin/env ruby

require 'pathname'
require 'fetch_local_lib'

puts "Working with #{$0}"

$PLUGIN_DIR = Pathname(ENV['CORDOVA_HOOK'] || $0).realpath.dirname.dirname.dirname.dirname
