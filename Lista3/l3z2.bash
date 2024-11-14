#!/bin/bash

# Użycie: ./l3z2.bash <nr_rewizji> <URL_repozytorium>

if [ $# -ne 2 ]; then
    echo "Użycie: $0 <nr_rewizji> <URL_repozytorium>"
    exit 1
fi

revision=$1
repo_url=$2
temp_dir=$(mktemp -d)

# Pobranie określonej rewizji z repozytorium SVN
svn checkout -r $revision $repo_url $temp_dir >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Błąd podczas pobierania z repozytorium."
    rm -rf $temp_dir
    exit 1
fi

# Znalezienie wszystkich plików tekstowych w pobranym katalogu, ignorując katalogi .svn
text_files=$(find "$temp_dir" -type f -not -path "*/.svn/*" -exec file {} \; | grep " text" | cut -d: -f1)

# Wyłuskanie wszystkich wystąpień słów z plików tekstowych i zliczenie ich całkowitej liczby
grep -hoE '\w+' $text_files | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr

# Usunięcie tymczasowego katalogu
rm -rf "$temp_dir"
