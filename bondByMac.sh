#!/bin/bash

#IPs and MAC addresses for server and NICs
#dont forget to change back to VARs
ip=$1
mac1=$2
mac2=$3

#get interface names to array
getInts="ls -1 /sys/class/net/|grep -v lo|grep -v bond"
result1="$(ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -q -o ConnectTimeout=5 root@$ip $getInts)"
interfaces_array=($result1)

#associative array to hold mac address as key and interface name as value
declare -A keyVal

#loop through interfaces_array and get mac, assign it to key
#structured as (mac,int) so you can access interface by MAC
for name in ${interfaces_array[*]}; do
    getMacs="cat /sys/class/net/$name/address"
    result2="$(ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -q -o ConnectTimeout=5 root@$ip $getMacs)"
    keyVal+=([$result2]=$name)
done

#get value by mac
int1=${keyVal[$mac1]}
int2=${keyVal[$mac2]}

echo $int1 $int2

#pass interface names to bond config and configure bond
bondConfig="wget http://9ab.org/dimitry/bonded.bash; chmod +x bonded.bash; ./bonded.bash $int1 $int2; reboot"
result2="$(ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -q -o ConnectTimeout=5 root@$ip $bondConfig)"