#!/bin/bash

# Użycie: ./l3z3.bash <nr_rewizji> <URL_repozytorium>

if [ $# -ne 2 ]; then
    echo "Użycie: $0 <nr_rewizji> <URL_repozytorium>"
    exit 1
fi

revision=$1
repo_url=$2
temp_dir=$(mktemp -d)

# Pobranie określonej rewizji z repozytorium SVN
svn checkout -r $revision $repo_url $temp_dir >/dev/null

if [ $? -ne 0 ]; then
    echo "Błąd podczas pobierania z repozytorium."
    rm -rf $temp_dir
    exit 1
fi

# Znalezienie wszystkich plików tekstowych w pobranym katalogu, ignorując katalogi .svn
text_files=$(find $temp_dir -type f -not -path "*/.svn/*" -exec file {} \; | grep " text" | cut -d: -f1)

# Wyłuskanie unikalnych słów z każdego pliku tekstowego,
# a następnie zliczenie liczby plików, w których wystąpiło każde słowo
(for f in $text_files; do
   grep -oE '\w+' "$f" | tr '[:upper:]' '[:lower:]' | sort -u | sed "s|^|$f |"
done) | awk '{print $2, $1}' | sort | uniq | awk '{count[$1]++} END{for(w in count) print count[w], w}' | sort -nr

# Usunięcie tymczasowego katalogu
rm -rf $temp_dir
