#!/bin/bash
if [ $# -ne 1 ]
then
echo "Usage: /home/student/categorize_other.sh [file] "
exit 1
fi
file=$1
categories=("system" "network_or_malware" "data_extraction" "navigation"
"privilege_escalation")
num_lines=$(cat $file | wc -l)
while [ $num_lines -gt 0 ]
do
# display categories
echo "1 = sys, 2 = net/mal, 3 = data, 4 = nav, 5 = priv, 6 = skip, 7 =
trash"
# print first line of file
sed -n 1p $file
read -p "Enter category: " category
if [ "$category" -ge 0 ] && [ "$category" -le 5 ]; then
# append this to end of file of other txt
echo "$(sed -n 1p $file) ${categories[category - 1]}" >>
/home/student/commands.txt
sed -n '2,$'p $file > /home/student/temp.txt
cp /home/student/temp.txt $file
rm /home/student/temp.txt
num_lines=$((num_lines - 1))
fi
# skip and move line to bottom of current file
if [ "$category" -eq 6 ]; then
sed -n '2,$'p $file > /home/student/temp.txt
sed -n 1p $file >> /home/student/temp.txt
cp /home/student/temp.txt $file
rm /home/student/temp.txt
fi
if [ "$category" -eq 7 ]; then
sed -i '1d' $file
line=$(sed -n 1p $file)
echo $line >> /home/student/trash.txt
fi
done