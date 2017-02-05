#!/bin/bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDER_DIR=builder

# Temporary symlink
ln $BASE_DIR/../tutorials $BUILDER_DIR/_tutorials

# Clean then build
cd $BUILDER_DIR
jekyll clean
jekyll build

# Clean up symlink
rm $BASE_DIR/$BUILDER_DIR/_tutorials
