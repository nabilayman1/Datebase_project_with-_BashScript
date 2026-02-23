#!/usr/bin/bash
read -p "entre name of DB to delete : " -r input
checkname.sh "$input"
status=$?
if [[ $status == 1 ]];then
    echo "DB name Must start With a Letter"
elif [[ $status == 2 ]];then
    echo "special char don't allow in DB name "
else
    cd $HOME/proj/DateBase
    if [ -d "$input" ]; then
        echo "Are you sure to delete this DB with name : $input "
        read -p "IF Yes type y: " -r ok
        if [[ $ok == "y" || $ok == "Y" || $ok == "yes" || $ok == "Yes" ]];then
            echo "Your File Delete in progress "
            rm -r "$input"
            echo "File Deleted, Sir with name : $input"
        else
            echo "Your DB not Deleted"
        fi
    else
        echo "File : $input Doesn't exist"
    fi
fi
