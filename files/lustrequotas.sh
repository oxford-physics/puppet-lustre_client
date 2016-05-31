#!/bin/bash
#ousers=`getent passwd | grep -v \:\! | cut -f 1 -d : | sort`
#ausers=`getent passwd | grep 350 | cut -f 1 -d : | sort `
#ausers="$ausers $ousers"
IFS=$'\n'
ausers=`ypcat  passwd | cut -f 1 -d :`
for i in $ausers; do speel=`lfs quota -u "$i" /lustre/atlas25/ | tail -1 | awk '{print "GB: "$1/1000000" Files: "$5}'`; printf "%-20s" "$i" ; printf " $speel \n";done | sort -nr -k 3 | uniq > /data/atlas/usage.txt
for i in $ausers; do speel=`lfs quota -u "$i" /lustre/lhcb25/ | tail -1 | awk '{print "GB: "$2/1000000" Files: "$6}'`; printf "%-20s" "$i"; printf " $speel \n";done | sort -nr -k 3 | uniq > /data/lhcb/usage.txt

