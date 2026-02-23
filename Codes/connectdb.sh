#!/usr/bin/bash
read -p "Name OF Date Base To connect : " -r input
checkname.sh "$input"
status=$?
if [[ $status == 1 ]];then
   echo "DB name Must start With a Letter"
elif [[ $status == 2 ]];then
    echo "special char don't allow in DB name"
else
    cd $HOME/proj/DateBase
    if [ -d "$input" ]; then
        echo "connited to DB ... "
        select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table OR Print It" "Delete From Table" "Update Table"
        do
            case "$REPLY" in
            1 )
                createtable.sh "$input"
            ;;
            2 )
                listtables.sh   "$input"
            ;;
            3 )
                droptable.sh "$input"
            ;;
            4 )
                inserttotable.sh "$input"
            ;;
            5 )
                selectfromtable.sh "$input"
            ;;
            6 )
                deletefromtable.sh "$input"
            ;;
            7)
                updatetable.sh "$input"
            ;;
            8 )
                break
                echo "you are in the main menu"
            ;;
            * )
                echo "Wrong Choice"
                echo "To Create Table Type ==> 1"
                echo "To List Tables Type ==> 2"
                echo "To Drop Table Type ==> 3"
                echo "To Insert into Table Type ==> 4"
                echo "To elect From Table OR Print It Type ==> 5"
                echo "To Delete From Table Type ==> 6"
                echo "To Update TableType ==> 7"
                echo "To Exit Type ==> 8"
            esac
        done
    else
        echo "No DateBase With Name : $input"
    fi
fi

            
                            
      


