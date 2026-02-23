#!/usr/bin/bash
read -p "entre name of table you want to delete : " -r delete
cd $HOME/proj/DateBase/"$1"
checkname.sh "$delete"
status=$?
if [[ $status == 1 ]];then
   echo "Table name Must start With a Letter"
elif [[ $status == 2 ]];then
    echo "special char don't allow in Table name"
else
    read -p "are you sure to delete this DB Table's if Yes type y: " -r ok
    if [[ $ok == "y" || $ok == "Y" || $ok == "yes" || $ok == "Yes" ]];then
        if [[ -f "$delete"  ]]; then
            echo "Dropping The Table in Progress .."
            rm -rf "$delete" "Metadateof$delete"
            echo "Dropping Table Succsefully"
        else
            echo "No Tables With This Name : "$delete" To Delete"
        fi
    else 
        echo "I Don't Understand Your Choice Table isn't Removed"
    fi
fi