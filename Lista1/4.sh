#!/bin/bash

declare -A words_files
dir="$1"

for file in $(./1.sh $dir); do
    declare -A current_file

    for word in $(cat $file); do
        if [ ! ${current_file["$word"]+yup} ]; then
            words_files["$word"]+=" $file"
            current_file["$word"]="a"
        fi
    done
    unset current_file
done

for word in "${!words_files[@]}"; do
    echo "$word:"
    for file in ${words_files["$word"]}; do
        grep -nw -- "$word" "$file" | while IFS=: read -r line_num line_content; do
            printf "    %s:%d:%s\n" "$file" "$line_num" "$line_content"
        done
    done
done