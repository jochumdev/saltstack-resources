#!/bin/sh
# http://stackoverflow.com/a/19029685

oldPWD=$(pwd)

cd formulas/saltstack-formulas
curl -s https://api.github.com/orgs/saltstack-formulas/repos?per_page=200 | ruby -rubygems -e '
  require "json";
  JSON.load(STDIN.read).each {
    |repo|
    if !File.directory?(repo["name"])
      print "git submodule add #{repo["clone_url"]} #{repo["name"]} "
      %x[ git submodule add #{repo["clone_url"]} #{repo["name"]} ]
    end
  }
'

cd $oldPWD
cd formulas/bechtoldt
curl -s https://api.github.com/orgs/bechtoldt/repos?per_page=200 | ruby -rubygems -e '
  require "json";
  JSON.load(STDIN.read).each {
    |repo|
    if !File.directory?(repo["name"])
      print "git submodule add #{repo["clone_url"]} #{repo["name"]} "
      %x[ git submodule add #{repo["clone_url"]} #{repo["name"]} ]
    end
  }
'

# git submodule update --init --recursive
git submodule foreach --recursive git fetch
git submodule foreach git pull --ff-only origin master
