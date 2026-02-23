#!/usr/bin/bash
mypath="$HOME/proj/DateBase/"$1""
if [[ -n "$(find "$mypath" -mindepth 1 -maxdepth 1 -type f)" ]]; then
    echo "Table you have :"
    ls -l $HOME/proj/DateBase/$1 | tail -n +2 | awk '{print "-Table name:",$9,"-created by:",$3,"-creation date:",$8,$7,$6}' 
else
    echo "You don't have any Tables"  
fi