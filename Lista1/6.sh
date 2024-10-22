#!/bin/bash

dir="$1"

declare -A words_files

# Loop over every file in the directory
for file in $(./1.sh $dir); do
    while read -- line; do
        declare -A stats
        for word in $line; do
            if [ "${stats[$word]}" = 'first' ]; then
                words_files["$word"]+="$file:$line\n"
                stats["$word"]="second"
            elif [ "${stats[$word]}" = '' ]; then
                stats["$word"]="first"
            fi
        done
        unset stats
    done <"$file"
done

# Print the stats grouped by word
for word in "${!words_files[@]}"; do
    echo "$word:"
    printf "%b" "${words_files[$word]}" | while IFS=: read -r file line; do
        line_num=$(grep -n -- "$line" "$file" | cut -d: -f1)
        printf "    %s:%d:%s\n" "$file" "$line_num" "$line"
    done
done