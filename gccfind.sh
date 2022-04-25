#!/bin/bash
#Ben Ganon 318731007

find() {
  if [[ $1 == '' || $2 == '' ]]; then
    echo Not enough parameters
    exit
  fi
  
  cd $1
  shopt -s nullglob
  local fileArray=(*)
  local compileArr=()
  shopt -u nullglob
  searchWord=${2,,}
  regex='\b'$searchWord'\b'

  for file in ${fileArray[@]}
  do
    if [[ $file == *.out ]]
    then
      rm $file
    fi

    if [[ -d $file && $3 == '-r' ]]; then
      local localDir=$PWD
      find $PWD'/'$file $2 -r
      cd $localDir
      continue
    fi

    if [[  $file == *.c ]]; then
      filename=${file:0:(-2)}
      if grep -q -w -i $regex $file
      then
        compileArr+=($file)
      fi
    fi

  done;
  for file in ${compileArr[@]}; do
    echo "compiled" $PWD'/'$file
    gcc -o $file.out -w $file
  done
  return
}

find $1 $2 $3

