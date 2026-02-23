#!/usr/bin/bash

cd "$HOME/proj/DateBase/$1" || { echo "Directory not found"; exit 1; }

read -p "Enter name of your Table to select from: " -r table
checkname.sh "$table"
status=$?

if [[ $status == 1 ]]; then
    echo "Table name must start with a letter"
    exit 1
elif [[ $status == 2 ]]; then
    echo "Special characters not allowed in DB name"
else
    if [[ -f "$table" ]]; then
        read -p "Enter your input to search: " -r id

        result=$(tail -3 "$table" | grep "$id")
        if [[ -n "$result" ]]; then
            echo "== We found output like =="
            echo "$result"
        else
            echo "Value '$id' not found in table!"
        fi
    fi
fi