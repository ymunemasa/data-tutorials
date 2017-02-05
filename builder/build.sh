#!/bin/bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SETTINGS_DIR=$BASE_DIR/settings

# Temporary symlink
ln -s $BASE_DIR/../tutorials $SETTINGS_DIR/_tutorials

# Clean then build
cd $SETTINGS_DIR
jekyll clean
jekyll build

# Clean up symlink
rm $SETTINGS_DIR/_tutorials
