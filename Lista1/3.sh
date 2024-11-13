#/bin/bash

declare -A stats
dir="$1"

for file in $(./1.sh $dir); do
    declare -A current_file

    for word in $(cat $file); do
        if [ ! ${current_file["$word"]+yup} ]; then
            if [ ${stats["$word"]+yup} ]; then
                ((stats["$word"]++))
            else
                ((stats["$word"]=1))
            fi
            current_file["$word"]="a"
        fi
    done
    unset current_file
done

echo "Word : File_Count"
for word in "${!stats[@]}"; do
    printf -- "$word : ${stats[$word]}\n"
done
