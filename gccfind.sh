#!/bin/bash
cd $1
shopt -s nullglob
fileArray=(*)
compileArr=()
shopt -u nullglob
searchWord=${2,,}
regex='([:punct:])*'$searchWord'([:punct:])*'

for file in ${fileArray[@]}
do

  if [[ $file == *.out ]]
  then
    echo "deleted:" $file
    rm $file
  fi

  if [[ -d $file && $3 != '' && $3 == '-r' ]]; then
    echo "inside recursive: " $PWD $file
  fi

  if [[  $file == *.c ]]; then
    filename=${file:0:(-2)}
    if [[ (${filename,,} =~ ^$regex$) ]]; then
      compileArr+=($filename)
      echo "compiling: " $file
      gcc -o $filename.out -w $file
    fi
  fi


done;
echo "compile array: " ${compileArr[@]}

exit
