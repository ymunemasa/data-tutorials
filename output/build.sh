#!/bin/bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDER_DIR=builder

# Temporary symlink
ln $BASE_DIR/../tutorials _tutorials

# Clean then build
jekyll clean
jekyll build

# Clean up symlink
rm $BASE_DIR/_tutorials
