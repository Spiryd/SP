#!/bin/bash

function list_files_in_a_directory() {
    local dir="$1"
    dir=${dir%/}

    for file in $dir/*; do
        if [ -f "$file" ]; then
            printf "$file\n"
        elif [ -d "$file" ]; then
            list_files_in_a_directory "$file"
        fi
    done
}

list_files_in_a_directory $1