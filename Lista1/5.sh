#!/bin/bash

dir="$1"

for file in $(./1.sh "$dir"); do
    cat "$file" | tr a A > /tmp/.tmp-5
    rm "$file"
    mv /tmp/.tmp-5 "$file"
done