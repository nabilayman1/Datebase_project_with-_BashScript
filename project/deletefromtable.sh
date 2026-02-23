#!/usr/bin/bash

cd "$HOME/proj/DateBase/$1"

read -p "Enter table name to delete from: " -r table
checkname.sh "$table"
status=$?

if [[ $status == 1 ]];then
    echo "DB name Must start With a Letter"
elif [[ $status == 2 ]];then
    echo "special char don't allow in DB name"
else
    if [[ -f "$table" ]]; then
        echo "connecting to table to deleting item ... "

        # قراءة أسماء الأعمدة وأنواعها
        IFS=':' read -r -a collist < <(head -n 1 "$table")
        IFS=':' read -r -a coltypes < <(sed -n '2p' "$table")
        colpk=$(sed -n '3p' "$table" | cut -d':' -f2) #==> هنا عشان اخش جوا $table السطر الاتالت واقطع الجزء اللي بعد : اخد منه الجزء التاني

        # إيجاد index العمود اللي هو PK
        for i in "${!collist[@]}"; do
            if [[ "${collist[$i]}" == "$colpk" ]]; then
                pk_index=$i
                break
            fi
        done

        # نوع العمود PK
        pk_type=${coltypes[$pk_index]}

        # إدخال قيمة الـ PK المراد حذفها
        # التحقق من النوع
        while true ;do
            read -p "Enter $colpk value to delete: " -r del_value
            if [[ "$pk_type" == "Integer" ]];then
                if [[ "$del_value" =~ ^[0-9]+$ ]];then 
                    echo "== correct input =="
                    break
                else
                    echo "$colpk Must br Integer"
                    continue
                fi
            elif [[ "$pk_type" == "String"  ]]; then
                if [[ "$del_value" =~ ^[a-zA-Z]+$ ]];then 
                    echo "== correct input =="
                    break
                else
                    echo "$colpk Must br String"
                    continue
                fi
            elif [[ "$pk_type" == "Mixed"  ]]; then 
                echo "You Entre Mixed Value "
                break
            fi
        done

        # البحث عن القيمة وحذفها
        found=0
        while IFS=: read -r -a row; do
           head -n 3 "$table" > "$table.tmp"
            if [[ "${row[$pk_index]}" == "$del_value" ]]; then
                found=1
                continue #==> عشان ميكتبش في الملف المؤقت كدا هيعدي هنا انه يكتب 
            fi
            echo "${row[*]}" >> "$table.tmp" #==> هنا ليه استخدمت rows[*] عشان انا هنا بقوله حط كل دا كسطر واحد انما لو استخدمت rows[@] هقوله حط كل عنصر جواك في سطر 
        done < <(tail -n +3 "$table") #==> هنا عشان ياخد table كدخل لل function تاعت while
        if [[ $found == 1 ]]; then
            mv "$table.tmp" "$table"
            echo "Row with "$colpk"="$del_value" deleted successfully!"
        else
            rm "$table.tmp"
            echo "Value '$del_value' not found in column $colpk!"
        fi
    else 
        echo "No Table With This Name "
    fi
fi
