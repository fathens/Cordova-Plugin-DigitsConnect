#!/usr/bin/env ruby

require 'pathname'

def setup_plugin(plugin_dir)
    ENV['PLUGIN_DIR'] = plugin_dir.to_s
    FetchLocalLib::Repo.bitbucket(plugin_dir, "lineadapter_android", tag: "version/3.1.21").git_clone
    rewrite_gradle plugin_dir/'platforms'/'android'/'plugin.gradle'
end

if $0 == __FILE__
    setup_plugin Pathname(ENV['CORDOVA_HOOK'] || $0).realpath.dirname.dirname.dirname.dirname
end
