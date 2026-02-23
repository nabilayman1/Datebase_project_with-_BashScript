#!/usr/bin/bash

read -p "Enter Table Name: " -r table

cd $HOME/proj/DateBase/"$1"
checkname.sh "$table"
status=$?

if [[ $status == 1 ]]; then
    echo "Table name must start with a letter"
elif [[ $status == 2 ]]; then
    echo "Special characters not allowed in table name"
else
    if [[ ! -f "$table" ]]; then
        echo "No table with this name: $table"
        exit 1
    fi
    echo "Connected to Table: $table"

    IFS=':' read -r -a collist < <(head -n 1 "$table")
    IFS=':' read -r -a coltypes < <(sed -n '2p' "$table")
    colpk=$(sed -n '3p' "$table" | cut -d':' -f2)

    for i in "${!collist[@]}"; do
        if [[ "${collist[$i]}" == "$colpk" ]]; then
            pk_index=$i
            break
        fi
    done

    pk_values=($(awk -F: -v col=$((pk_index+1)) 'NR>3 {print $col}' "$table")) # -v to make variable into awk

    while true; do
        echo "=== Enter New Row ==="
        row=()

        for ((i=0; i<${#collist[@]}; i++)); do
            col="${collist[$i]}"
            type="${coltypes[$i]}"

            while true; do
                read -p "$col ($type): " -r value

                if [[ "$type" == "Integer" ]]; then
                    [[ "$value" =~ ^[0-9]+$ ]] || { echo "Must be integer"; continue; }
                elif [[ "$type" == "String" ]]; then
                    [[ "$value" =~ ^[a-zA-Z]+$ ]] || { echo "Letters only"; continue; }
                fi

                if [[ $i == $pk_index ]]; then
                    if [[ " ${pk_values[@]} " =~ " $value " ]]; then
                        echo "Error: Primary Key value '$value' already exists! Enter a unique value."
                        continue
                    else
                        pk_values+=( "$value" )
                    fi
                fi

                row+=( "$value" )
                break
            done
        done

        printf "%s" "${row[0]}" >> "$table"
        for var in "${row[@]:1}"; do
            printf ":%s" "$var" >> "$table"
        done
        printf "\n" >> "$table"

        echo "Row added successfully!"

        read -p "Add another row? (y/n): " -r ans
        [[ "$ans" != "y" && "$ans" != "Y" ]] && break
    done

    echo "Data insertion finished."
fi