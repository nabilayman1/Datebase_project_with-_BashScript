#!/usr/bin/bash
read -p "entre name of your new Date Base to create : " -r input
checkname.sh "$input"
status=$?
if [[ $status == 1 ]];then
    echo "DB name Must start With a Letter"
elif [[ $status == 2 ]];then
    echo "special char don't allow in DB name"
else
    echo "Your File Creatation in progress .. "
    cd $HOME/proj/DateBase
    if [ -e "$input" ]; then
        echo "we can't create DB with name already exist"
    else
        mkdir "$input" 2> /dev/null
        echo "File Created, Sir with name : $input"
    fi
fi