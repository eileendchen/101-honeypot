#!/bin/bash
#creating dict
declare -A count_dict
count_dict["other"]=0
count_dict["data_extraction"]=0
count_dict["navigation"]=0
count_dict["system"]=0
count_dict["privilege_escalation"]=0
count_dict["network_or_malware"]=0
# This script will be called after a honeypot is recycled
if [ $# -ne 1 ]
then
sudo echo "Usage: logfile"
exit 1
Fi
file_architecture=$(sudo echo $1 | cut -d"/" -f5)
date=$(sudo echo $1 | cut -d"/" -f7)
sudo touch /tmp/processing$date
sudo chmod +w /tmp/processing$date
grep "line from reader" $1 | cut -d" " -f9- | sudo tee -a /tmp/processing$date
> /dev/null 2>&1
grep "Noninteractive mode attacker command" $1 | cut -d" " -f10- | sudo tee -a
/tmp/processing$date > /dev/null 2>&1
count=0
commandFile="/home/student/just_commands.txt"
awk 'BEGIN{FS=OFS=" "}{NF--; print}' /home/student/commands.txt > $commandFile
cat /dev/null | sudo tee -a /home/student/other_check.txt > /dev/null 2>&1
while IFS= read -r line
do
IFS=";&|"
read -ra array <<< "$line"
for element in "${array[@]}"
do
count=$(( $count + 1 ))
command=$(echo "${element# *}" | sed 's/[[:space:]]*$//')
if ! grep -qFx "$command" /home/student/trash.txt
then
if [ ! -z $command ]
then
line_num=$( cat $commandFile | grep -Fnx "$command"| head -1 | cut

-d':' -f1)

if [ ! -z $line_num ]
then
category=$(sed -n "${line_num}p" /home/student/commands.txt | rev

| cut -d" " -f1 | rev)

category=${category%"${category##*[![:space:]]}"}

# increment counter value in the dictionary if command already

found

count_dict["$category"]=$(( count_dict["$category"] + 1 ))
else
if ! grep -q "$command" /home/student/other.txt
then
sudo echo "$command" | sudo tee -a /home/student/other.txt >

/dev/null 2>&1
fi
count_dict["other"]=$(( count_dict["other"] + 1))
sudo echo "$command $1" | sudo tee -a
/home/student/other_check.txt > /dev/null 2>&1

fi
fi
fi
done
done < /tmp/processing$date
day=$(sudo echo $1 | cut -d"/" -f6)
if [ ! -d /home/student/data/"$file_architecture"/"$day" ]
then
sudo mkdir /home/student/data/"$fle_architecture"/"$day"
Fi
if [ -f /home/student/data/"$file_architecture"/"$day"/event_$date ]
then
sudo rm /home/student/data/"$file_architecture"/"$day"/event_$date
fi
echo "Categories:" | sudo tee -a
/home/student/data/"$file_architecture"/"$day"/event_"$date" > /dev/null 2>&1
echo "Data Extraction: ${count_dict["data_extraction"]}" | sudo tee -a
/home/student/data/"$file_architecture"/"$day"/event_"$date" > /dev/null 2>&1
echo "Navigation: ${count_dict["navigation"]}" | sudo tee -a
/home/student/data/"$file_architecture"/"$day"/event_"$date" > /dev/null 2>&1
echo "System: ${count_dict["system"]}" | sudo tee -a
/home/student/data/"$file_architecture"/"$day"/event_"$date" > /dev/null 2>&1
echo "Privilege Escalation: ${count_dict["privilege_escalation"]}" | sudo tee
-a /home/student/data/"$file_architecture"/"$day"/event_"$date" > /dev/null
2>&1
echo "Network or Malware: ${count_dict["network_or_malware"]}" | sudo tee -a
/home/student/data/"$file_architecture"/"$day"/event_"$date" > /dev/null 2>&1
echo "Other: ${count_dict["other"]}" | sudo tee -a
/home/student/data/"$file_architecture"/"$day"/event_"$date" > /dev/null 2>&1
echo " ------------------------------------------ " | sudo tee -a
/home/student/data/"$file_architecture"/"$day"/event_"$date" > /dev/null 2>&1
cat /tmp/processing$date | sudo tee -a
/home/student/data/"$file_architecture"/"$day"/event_"$date" > /dev/null 2>&1
sudo rm /tmp/processing$date