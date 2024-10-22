#!/bin/bash

declare -A stats
dir="$1"

for file in $(./1.sh $dir); do
    for word in $(cat $file); do
        if [ ${stats["$word"]+yup} ]; then
            ((stats["$word"]++))
        else
            ((stats["$word"]=1))
        fi
    done
done

echo "Word : Count"
for word in "${!stats[@]}"; do
    printf -- "$word : ${stats[$word]}\n"
done