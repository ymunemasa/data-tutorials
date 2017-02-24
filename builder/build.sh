#!/bin/bash

baseDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
settingsDir=$baseDir/config

# Get git values
gitBranch=$(git rev-parse --abbrev-ref HEAD) # (e.g. master)
gitUserAndRepository=$(git remote get-url origin | sed s/.*github.com\\///g | sed s/\.git//g) # (e.g. orendain/big-data-tutorials)

# Github raw content base URL (e.g. https://raw.githubusercontent.com/orendain/big-data-tutorials/master)
githubRawUrl="https://raw.githubusercontent.com/$gitUserAndRepository/$gitBranch"

# http://stackoverflow.com/questions/20348097/bash-extract-string-before-a-colon
# cut -d- -f1

# Temporary symlink
#ln -s $baseDir/../tutorials $settingsDir/_tutorials

rm -Rf $settingsDir/_tutorials

# Copy over the files (rather than symlink because we'll be making temporary source changes)
cp -r $baseDir/../tutorials $settingsDir/_tutorials

echo "Performing preprocessing..."

# Preprocessing: Go through the raw pages and do the following:
# - Prepare to replace relative asset references to their Github equivalents
# - Replace curly quotes with straight quotes
for f in $(find $settingsDir/_tutorials -type f -name "*.md")
do
  # This converts strings like this:
  # assets/asset-name.jpg
  # To something like this:
  # tutorials/hdp/hdp-2.5/name-of-the-tutorial/tutorial.md/assets/asset-name.jpg
  sed -i '' s/\(assets/\({{page.path}}\\/assets/g $f
  #perl -p -i '' -e 's|(\/.*)\/(.*md)|\1|' $f

  sed -i '' s/[‘’]/\'/g $f
  sed -i '' s/[”“]/'"'/g $f
done

# Clean then build
cd $settingsDir
jekyll clean
jekyll build

echo "Performing postprocessing..."

cd $baseDir
# Postprocessing: Go through the raw pages and do the following:
# - Remove unecessary references from asset urls
# - Link assets to Github raw content
for f in $(find ./output -type f -name "*.html")
do
  echo "Processing file $f"
  #sed s/src=\"assets/src=\"{{page.path}}\\/assets/g
  #sed -i '' s/src=\"_tutorials/src=\"githubRawUrl\\/tutorials/g $f
  #sed -i '' "s|\(_\)\(\/.*\)\/\(.*md\)|//$githubRawUrl\/\2|g" $f

  sed -i '' "s|\(_\)\(.*\)\/\(.*md\)|$githubRawUrl/\2|g" $f

  #perl -p -i '' -e 's|(\/.*)\/(.*md)|\1|' $f
done

# Go through the built pages and do the following:
# - Link assets to github URLs
# - Replace curly quotes with straight quotes
#for f in $(find ./output -type f -name "*.html")
#do
#  if [[ $f == *.html ]]
#  then
#    sed -i '' "s/src=\"\/assets\//src=\"https:\/\/raw.githubusercontent.com\/hortonworks\/tutorials\/$BRANCH\/assets\//g" $f
#    sed -i '' s/[‘’]/\'/g $f
#    sed -i '' s/[”“]/'"'/g $f
#  fi
#done

# Remove the copied files
#rm -Rf $settingsDir/_tutorials

# Clean up symlink
#rm $settingsDir/_tutorials




## old live
#https://raw.githubusercontent.com/hortonworks/tutorials/hdp/assets/deploying-on-ms-azure/01_azure_welcome.png

## intermediate

## future live
#https://raw.githubusercontent.com/hortonworks/big-data-tutorials/master/tutorials/hdp/hdp-2.5/deploying-on-ms-azure/assets/01_azure_welcome.png

## future template
#https://raw.githubusercontent.com/hortonworks/big-data-tutorials/$gitBranch/tutorials/$platformBase/$platform/$dashedDirectoryTitle/assets/$assetName

## (cp above) + within a page:
#https://raw.githubusercontent.com/hortonworks/big-data-tutorials/$gitBranchToGoHere/tutorials/$platformBase/$platform/$dashedDirectoryTitle/assets/$assetName
#                                                                                  |-----page.id--------------------------------------------+"tutorial"| # No rtaiing slash
## Linking to another post:
## Target: https://hortonworks.com/hadoop-tutorial/tutorial-name-here
##{{ site.url }}/tutorial-name-here


## Linking to an asset:
## Target: https://raw.githubusercontent.com/hortonworks/big-data-tutorials/$gitBranch/tutorials/$platformBase/$platform/$dashedDirectoryTitle/assets/$assetName
## User would type:
#assets/something.jpg
## Prescript would raw md to:
##{{ page.path }} /assets/assetname.jpg  #tutorials/hdp/hdp-2.5/some-random-title/tutorial.md/assets/asset-name.jpg

##echo "blah blah ssomeritnh src=\"assets/something.jpg\"" | sed s/src=\"assets/src=\"{{page.path}}\\/assets/g
## blah blah ssomeritnh src="{{page.path}}/assets/something.jpg"

## Would cut out middle to
#tutorials/hdp/hdp-2.5/some-random-title/assets/asset-name.jpg
## Postscript woould convert to:
#githubRawUrl / (above after cutting)


## Linking to asset in codeblock (same as above)


## cuts out 6th column
## echo "tutorials/hdp/hdp-2.5/some-random-title/tutorial.md/assets/asset-name.jpg" | cut -d'/' -f-4,6-
## > /tutorials/hdp/hdp-2.5/some-random-title/assets/asset-name.jpg


##Temporary
#https://raw.githubusercontent.com/orendain/tutorials/revamp/assets/a-short-primer-on-scala/Screenshot%202015-06-08%2012.26.39.png
