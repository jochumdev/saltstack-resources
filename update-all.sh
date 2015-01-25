#!/bin/sh
# http://stackoverflow.com/a/19029685

git submodule update --init --recursive
git submodule foreach --recursive git fetch
git submodule foreach git pull --ff-only origin master
