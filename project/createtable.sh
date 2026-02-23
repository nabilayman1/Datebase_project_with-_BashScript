#!/usr/bin/bash

cd "$HOME/proj/DateBase/$1"

read -p "Enter your table name: " -r table
checkname.sh "$table"
status=$?

if [[ $status == 1 ]]; then
    echo "Table name must start with a letter"
elif [[ $status == 2 ]]; then
    echo "Special characters not allowed in table name"
else
    if [[ -f "$table" ]]; then
        echo "Can't create table because table already exists: $table"
    else
        echo "Table creation in progress..."
        read -p "Enter number of columns: " colnum

        if [[ $colnum =~ ^[0-9]+$ ]]; then
            collist=()
            coltypes=()

            for ((i=0; i<colnum; i++)); do
                read -p "Enter column $((i+1)) name: " -r colname

                if [[ "$colname" =~ ^[a-zA-Z][a-zA-Z0-9]*$ ]]; then
                    collist+=( "$colname" )
                    echo "$colname added"

                    select type in String Integer Mixed; do
                        case "$REPLY" in
                            1) coltypes+=( "String" )
                                break 
                            ;;
                            2) coltypes+=( "Integer" )
                                break 
                            ;;
                            3) coltypes+=( "Mixed" )
                                break 
                            ;;
                            *) echo "Invalid choice" ;;
                        esac
                    done

                else
                    echo "Column name must start with letter and be alphanumeric only"
                    ((i--))
                fi
            done

            read -p "What's your Primary Key column name: " -r colpk
            found=0

            for i in "${!collist[@]}"; do   # !!! استخدم ! للحصول على index
                if [[ "${collist[$i]}" == "$colpk" ]]; then
                    found=1
                    pk_index=$i
                    break
                fi
            done

            if [[ $found == 1 ]]; then
                touch "$table"
                echo "Table created successfully"
                echo "Start inserting data"

                # كتابة أسماء الأعمدة
                printf "%s" "${collist[0]}" >> "$table"
                for var in "${collist[@]:1}" ;do
                    printf ":%s" "$var" >> "$table"
                done
                printf "\n" >> "$table"

                # كتابة أنواع الأعمدة
                printf "%s" "${coltypes[0]}" >> "$table"
                for var in "${coltypes[@]:1}" ;do
                    printf ":%s" "$var" >> "$table"
                done
                printf "\n" >> "$table"

                # كتابة primary key وسطر فارغ بعده
                echo "Primary Key:$colpk" >> "$table"
                

                # إدخال البيانات
                while true; do
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
                                exists=0
                                for val in "${pk_values[@]}"; do
                                    if [[ "$value" == "$val" ]]; then
                                        exists=1
                                        break
                                    fi
                                done
                                if [[ $exists == 1 ]]; then
                                    echo "Error: Primary Key value '$value' already exists! Enter a unique value."
                                    continue  # يرجع المستخدم يدخل قيمة جديدة
                                else
                                    pk_values+=( "$value" )  # لو مش موجودة → نضيفها
                                fi
                            fi

                            row+=( "$value" )
                            break
                        done
                    done

                    # طباعة الصف في الملف بدون : آخر العمود
                    printf "%s" "${row[0]}" >> "$table"
                    for var in "${row[@]:1}" ;do
                        printf ":%s" "$var" >> "$table"
                    done
                    printf "\n" >> "$table"

                    echo "Row added"
                    read -p "Add another row? (y/n): " -r ans
                    [[ "$ans" != "y" && "$ans" != "Y" ]] && break
                done

                echo "Data insertion finished"
            else
                echo "Primary Key column does not exist"
            fi
        else
            echo "Number of columns must be integer"
        fi
    fi
fi