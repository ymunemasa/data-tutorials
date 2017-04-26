#!/bin/bash

baseDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
settingsDir=$baseDir/config

# Get git values
gitBranch=$(git rev-parse --abbrev-ref HEAD) # (e.g. master)
gitCommit=$(git rev-parse --verify HEAD) # (last commit hash)
gitUserAndRepository=$(git remote get-url origin | sed s/.*github.com\\///g | sed s/\.git//g) # (e.g. orendain/big-data-tutorials)

# Github raw content base URL (e.g. https://raw.githubusercontent.com/orendain/big-data-tutorials/master)
#githubRawUrl="https://raw.githubusercontent.com/$gitUserAndRepository/$gitBranch"
githubRawUrl="https://raw.githubusercontent.com/$gitUserAndRepository/$gitCommit"

# Copy over the files (rather than symlink because we'll be making temporary source changes)
cp -r $baseDir/../articles $settingsDir/_articles

# Preprocessing: Go through the raw pages and do the following:
# - Prepare to replace relative asset references to their GitHub equivalents
# - Replace curly quotes with straight quotes
echo "Performing preprocessing..."
for f in $(find $settingsDir/_articles -type f -name "*.md")
do
  # This converts strings like this:
  # assets/asset-name.jpg
  # To something like this:
  # tutorials/hdp/hdp-2.5/name-of-the-tutorial/tutorial.md/assets/asset-name.jpg
  sed -i '' s/\(assets/\({{page.path}}\\/assets/g $f

  sed -i '' s/[‘’]/\'/g $f
  sed -i '' s/[”“]/'"'/g $f
done

# Clean then build
cd $settingsDir
jekyll clean
jekyll build

cd $baseDir
# Postprocessing: Go through the raw pages and do the following:
# - Remove unecessary references from asset urls
# - Link assets to Github raw content
echo "Performing postprocessing..."
for f in $(find ./output -type f -name "*.html")
do
  echo "Processing file $f"
  # Not the *most* pefect regex expression, but all edge cases caught thus far.
  sed -i '' "s|\(_\)\(articles.*\)\/\(.*[.]md\)|$githubRawUrl/\2|g" $f
done

# Remove the copied files
rm -Rf $settingsDir/_articles
