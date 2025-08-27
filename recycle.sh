#!/bin/bash
if [ $# -ne 2 ]
then
echo "Usage: [IP Number] [Random Port Number]"
exit 1
fi
if [[ ! $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
echo "Error: invalid IP"
exit 2
fi
IP=$1
port_num=$2
lastgroup=$(echo $IP | cut -d'.' -f4)
container_name="BB_Server_"$lastgroup
exists=$(sudo lxc-ls $container_name | grep $container_name -c)
# Stops and destroys container if it already exists
if [ "$exists" -eq 1 ]
then
sudo lxc-stop -n $container_name
sudo lxc-destroy -n $container_name
fi
# Runs once to install forever into system and activate eth1 interface
sudo ip link set dev "eth1" up
while true
do
# randomly selects config folder from data directory
con=$( ls /home/student/data | shuf -n 1 )
# Copy base container with openssh installed
sudo lxc-stop -n base
sudo lxc-copy -n base -N $container_name
sleep 10
sudo lxc-start -n $container_name
sleep 10
# transfer honey to container
if [ $con == "dir" ]
then
/home/student/create_direct.sh $container_name
elif [ $con == "seq" ]
then
/home/student/create_linear.sh $container_name
else
/home/student/create_binary.sh $container_name
fi

sleep 5
day="Day_$(date +%m_%d_%y)"
if [ ! -d /home/student/data/$con/$day ]
then
sudo mkdir /home/student/data/$con/$day
fi
containerIP=$(sudo lxc-info -n $container_name -iH)
logfile=data/$con/$day/$(date +%m_%d_%y_%H_%M_%S)
# start MITM server
sudo /usr/bin/forever --id $container_name --pidFile
/home/student/pids/$container_name.pid -l /home/student/"$logfile" start
/home/student/MITM/mitm.js -n $container_name -i $containerIP -p $port_num
--auto-access --auto-access-fixed 1 --debug
sleep 5
# PREROUTING & POSTROUTING rules
sudo sysctl -w net.ipv4.conf.all.route_localnet=1
sudo ip addr add $IP/24 brd + dev eth1
sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0
--destination $IP --jump DNAT --to-destination $containerIP
sudo iptables --table nat --insert POSTROUTING --source $containerIP
--destination 0.0.0.0/0 --jump SNAT --to-source $IP
# additional MITM redirection
sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0
--destination $IP --protocol tcp --destination-port 22 --jump DNAT
--to-destination "127.0.0.1:$port_num"
flag=true # flag to signify recycling
attacker_flag=false # flag to determine if attacker is present in honeypot
last_line=1 # represents the line in the MITM log where the last attacker
entered
start=$(date +%s) # changes after first attacker enters
initial_time=$(date +%s) # does not change
first_attacker=false # flag to determine if FIRST attacker has entered
attacker_ip="NONE"
monfile="/home/student/monitoring/"$container_name
# seperate monitoring file to see variable states
# while container is within time frame
while $flag
do
cat /dev/null > $monfile # clear monitoring file
echo $'\n'"Temp values before end of while: " >> $monfile
curr=$(date +%s) # current time
if sed -n "${last_line},\$p" /home/student/"$logfile" | grep -q "Attacker
authenticated and is inside container"
then

if [ "$attacker_flag" != "true" ]
then
if ! $first_attacker
then
first_attacker=true
start=$(date +%s) # Time of first attacker entry.
# outputs the time stamp for each attacker entry
ip_file="/home/student/ip_data/ip_$(echo $IP | cut -d"." -f4).txt"
echo "$(date +"%D %T") $start $logfile" >> $ip_file
fi
attacker_ip=$(sed -n "${last_line},\$p" /home/student/"$logfile" |

grep "Attacker connected" | tail -1 | cut -d' ' -f8)

# Ensuring that two attackers can't enter honeypot simutaneiously
sudo iptables --insert INPUT --protocol tcp --source 0.0.0.0/0
--destination "127.0.0.1" --destination-port $port_num --jump DROP

sudo iptables --insert INPUT --protocol tcp --source $attacker_ip
--destination "127.0.0.1" --destination-port $port_num --jump ACCEPT

attacker_flag=true
fi
fi
# delete rules for only allowing same attacker into honeypot once
connection is closed
if $attacker_flag
then
if sed -n "${last_line},\$p" /home/student/"$logfile" | grep -q
"Attacker closed connection"
then
attacker_ip=$(sed -n "${last_line},\$p" /home/student/"$logfile" |

grep "Attacker connected" | tail -1 | cut -d' ' -f8)

sudo iptables --delete INPUT --protocol tcp --source 0.0.0.0/0
--destination "127.0.0.1" --destination-port $port_num --jump DROP

sudo iptables --delete INPUT --protocol tcp --source $attacker_ip
--destination "127.0.0.1" --destination-port $port_num --jump ACCEPT

attacker_flag=false
last_line=$(cat /home/student/"$logfile" | grep -n -o

"$attacker_time" | cut -d":" -f1)
last_line=$(( $last_line + 1 ))
fi
fi
#Change time here as needed
enter_time=$(($curr - $start))
total_time=$(($curr - $initial_time))
total_time=$(($total_time / 60))
# if time after log in exceeds 30 seconds than recycle
if [[ $enter_time -ge 30 && $first_attacker == "true" ]]
then
flag=false
fi
# if there has been no interaction for more than 30 minutes, recycle

if [[ $total_time -ge 30 ]]
then
flag=false
curr=$(date)
echo "$IP $(date +"%D %T.%N") $logfile" >>
/home/student/recycle_alerts.txt
fi
# OUTPUT variables to monitoring file
echo $container_name >> $monfile
echo $'\n'"Values at end of while: " >> $monfile
echo "Variables -----------------------" >> $monfile
echo total time: $total_time >> $monfile
echo start: $start >> $monfile
echo last line: $last_line >> $monfile
echo attacker time: $attacker_time >> $monfile
echo attacker ip: $attacker_ip >> $monfile
echo "Flags ---------------------------" >> $monfile
echo first_attacker: $first_attacker >> $monfile
echo attacker_flag: $attacker_flag >> $monfile
sleep 5
done
# Destroying the honeypot, resetting NAT rules, and resetting MITM
sudo iptables --table nat --delete PREROUTING --source 0.0.0.0/0
--destination $IP --jump DNAT --to-destination $containerIP
sudo iptables --table nat --delete POSTROUTING --source $containerIP
--destination 0.0.0.0/0 --jump SNAT --to-source $IP
sudo iptables --table nat --delete PREROUTING --source 0.0.0.0/0
--destination $IP --protocol tcp --destination-port 22 --jump DNAT
--to-destination "127.0.0.1:$port_num"
sudo ip addr del $IP/24 brd + dev eth1
# sanity check for iptable
/home/student/check_iptable_once.sh $IP $port_num $logfile
sudo lxc-stop -n $container_name
sudo lxc-destroy -n $container_name
# Killing the forever processing running the MITM server by extracting the
unique ID we assigned to the MITM process
pid=$(cat /home/student/pids/$container_name.pid)
sudo rm -rf /home/student/pids/$container_name.pid
sudo /usr/bin/forever stop $pid
/home/student/categorize_commands.sh $logfile
done