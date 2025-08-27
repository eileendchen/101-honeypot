#!/bin/bash
filepath="category_analysis/final/"
cat /dev/null > $filepath"dir.txt"
cat /dev/null > $filepath"tree.txt"
cat /dev/null > $filepath"seq.txt"
categories=("data" "nav" "sys" "priv" "net")
# creates a concatenated list of the number counts in every event file
for arch in data/*
do
arch_str=$( echo $arch | cut -d'/' -f2 )
for day in "$arch"/*
do
for log in "$day"/event_*
do
cat "$log" | sed -n '2,7 p' | rev | cut -d" " -f1 | rev >>
"$filepath""$arch_str"".txt"
done
echo "done $day"
done
echo "done $arch"
done
# gets every line mod count and concatenates the three architectures in
parallel with a comma delimiter (csv file)
count=1
for name in "${categories[@]}"
do
paste <( cat $filepath"dir.txt" | awk -v var="$count" 'NR % 6 == var') <( cat
$filepath"seq.txt" | awk -v var="$count" 'NR % 6 == var') <( cat
$filepath"tree.txt" | awk -v var="$count" 'NR % 6 == var') >
"$filepath""$name"".txt"
count=$(( count + 1 ))
done