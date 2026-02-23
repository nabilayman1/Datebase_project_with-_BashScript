#!/usr/bin/bash
mypath="$HOME/proj/DateBase"
if [[ "$(find "$mypath" -mindepth 1 -maxdepth 1 -type d)" ]]; then
    echo "Date Base you have :"
    ls -l $HOME/proj/DateBase | tail -n +2 | awk '{if (substr($0,1,1)=="d") print "-DateBase name:",$9,"-created by:",$3,"-creation date:",$8,$7,$6}' 
else
    echo "You don't have any DB"    
fi