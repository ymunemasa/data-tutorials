for f in $(find ./hortonworks -name "*.md")
do
  if [[ $f == *.md ]]
  then
    echo $f
    tail -n +2 $f > temp
    mv temp $f
    echo 'layout: tutorial' | cat - $f > temp && mv temp $f
    echo '---' | cat - $f > temp && mv temp $f
  fi
done