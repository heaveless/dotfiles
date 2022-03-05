#!/bin/bash

base_files=`ls -a`
config_folders=`ls ./.config`

ignord=`cat .linkedignore`

# linked base files

if ! grep -q deps.sh ./.linkedignore; then
  echo "find me"
fi

echo ":tad: linked base files"

for entry in $base_files 
do
  echo "$entry"
done

# linked config folders

echo ":tada: Linked folders"

for entry in $config_folders
do 
  echo "$entry"
done


