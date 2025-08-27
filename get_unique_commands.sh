#!/bin/bash
if [ $# -ne 1 ]
then
echo "usage: ./get_unique_commands.sh [output file]"
exit 1
fi
cat /dev/null > tempfile.txt
cat /dev/null > tempfile2.txt
for arch in data/*/*
do
cat <(grep "Noninteractive" $arch/* | cut -d' ' -f10-) <(grep "line from
reader" $arch/* | cut -d' ' -f9-) >> tempfile.txt
done
while IFS= read -r line
do
IFS=";&|"
read -ra array <<< "$line"
for elment in "${array[@]}"
do
echo "${elment# *}" >> tempfile2.txt
done
done < tempfile.txt
sort tempfile2.txt | sed 's/[[:space:]]*$//' | uniq -c > $1
rm tempfile.txt
rm tempfile2.txt