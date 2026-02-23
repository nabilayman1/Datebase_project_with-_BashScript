#!/usr/bin/bash

cd "$HOME/proj/DateBase/$1"

read -p "Enter table name to update: " -r table
checkname.sh "$table"
status=$?

if [[ $status == 1 ]]; then
    echo "DB name must start with a letter"
elif [[ $status == 2 ]]; then
    echo "Special characters not allowed in DB name"
else
    if [[ -f "$table" ]]; then
        echo "Connecting to table to update item ..."

        IFS=':' read -r -a collist < <(head -n 1 "$table")
        IFS=':' read -r -a coltypes < <(sed -n '2p' "$table")
        colpk=$(sed -n '3p' "$table" | cut -d':' -f2)

        for i in "${!collist[@]}"; do
            if [[ "${collist[$i]}" == "$colpk" ]]; then
                pk_index=$i
                break
            fi
        done
        pk_type=${coltypes[$pk_index]}

        while true ;do
            read -p "Enter $colpk value to Update: " -r update_value
            if [[ "$pk_type" == "Integer" ]];then
                if [[ "$update_value" =~ ^[0-9]+$ ]];then 
                    echo "== correct input =="
                    break
                else
                    echo "$colpk Must br Integer"
                fi
            elif [[ "$pk_type" == "String"  ]]; then
                if [[ "$update_value" =~ ^[a-zA-Z]+$ ]];then 
                    echo "== correct input =="
                    break
                else
                    echo "$colpk Must br String"
                fi
            elif [[ "$pk_type" == "Mixed"  ]]; then 
                echo "You Entre Mixed Value "
                break
            fi
        done

        echo "name of coloums you have"
        echo ${collist[@]}
        read -p "Enter column name to update: " -r target_col
        col_found=0
        for i in "${!collist[@]}"; do
            if [[ "${collist[$i]}" == "$target_col" ]]; then
                target_index=$i
                target_type=${coltypes[$i]}
                col_found=1
                break
            fi
        done
        if [[ $col_found == 0 ]]; then
            echo "Column '$target_col' not found!"
            exit 1
        fi

        while true; do
            read -p "Enter new value for $target_col Which should be "$target_type" : " -r new_value
            if [[ "$target_type" == "Integer" && ""$new_value"" =~ ^[0-9]+$ ]]; then
                break
            elif [[ "$target_type" == "String" && ""$new_value"" =~ ^[a-zA-Z" "]+$ ]]; then
                break
            elif [[ "$target_type" == "Mixed" ]]; then
                echo "== You Entre Mixed Input =="
                break
            else
                echo "Invalid type for $target_col, try again"
            fi
        done

        head -n 3 "$table" > "$table.tmp"

        found=0
        while IFS=: read -r -a row; do
            if [[ "${row[$pk_index]}" == "$update_value" ]]; then
                row[$target_index]="$new_value"
                found=1
            fi
            (IFS=:; echo "${row[*]}") >> "$table.tmp"
        done < <(tail -n +4 "$table")

        if [[ $found -eq 1 ]]; then
            mv "$table.tmp" "$table"
            echo "Row with $colpk=$update_value updated successfully!"
        else
            rm "$table.tmp"
            echo "Value '$update_value' not found in column $colpk!"
        fi
    else
        echo "Table Not Found"
    fi
fi
