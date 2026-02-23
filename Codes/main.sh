#!/usr/bin/bash
echo "your are in the new main"
select choice in "Create New Date Base" "List Date Base" "Delete Date Base" "Conect To Date Base" "Exit"
do
    case "$REPLY" in
        1 )
            createdatebase.sh
        ;;
        2 )
            listdatebase.sh
        ;;
        3 )
            deletedatebase.sh
        ;;
        4 )
            connectdb.sh
        ;;
        5 )
        break
        ;;
        * )
        echo "Wrong Choice"
        echo "To Create New Date Base Type ==> 1"
        echo "To List Date Base Type ==> 2"
        echo "To Delete Date Base Type ==> 3"
        echo "To Conect To Date Base Type ==> 4"
        echo "To Exit Type ==> 5"
    esac
done