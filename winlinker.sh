#!/bin/bash

home_folders=`find $WINHOME -mindepth 1 -maxdepth 1 -type d | sed 's/ /-/g'`
home_direction=`realpath ~/`

# linked home folders

for entry in $home_folders
do 
  fmt_entry="${entry//-/ }";
  folder="$(echo $entry | grep -oE "[^/]+$" | sed -e 's/\(.*\)/\L\1/')";

  echo "Linked $fmt_entry => $home_direction/$folder";

  rm -rf "$home_direction/$folder";
  ln -s "$fmt_entry" "$home_direction/$folder";
done

