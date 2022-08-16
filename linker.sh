#!/bin/bash

config_files=`find . -maxdepth 1 -type f`
config_folders=`find ./.config/ -mindepth 1 -maxdepth 1 -type d`
config_direction=`realpath ~/`

# linked config files

for entry in $config_files 
do
  match=false

  while read line;
  do
    if [ -z $line ]; 
    then
      break
    fi

    if [ $line -ef $entry ];
    then
      match=true
      break
    fi
  done < .linkedignore

  if ! [[ $match == true ]];
  then
    echo "Linked $(realpath $entry) => $config_direction${entry:1}";

    rm -f "$config_direction${entry:1}";
    ln -s "$(realpath $entry)" "$config_direction";
  fi
 done

# linked config folders

for entry in $config_folders
do 
  echo "Linked $(realpath $entry) => $config_direction${entry:1}";

  rm -rf "$config_direction${entry:1}";
  ln -s "$(realpath $entry)" "$config_direction/.config/";
done

