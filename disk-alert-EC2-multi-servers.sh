#check several servers within EC2 group. It needs a file with a list of server IP/domain name on a single line. 

#! /bin/bash

ADMIN="serveralerts@youraddress.com"
ALERT=85

for SERVER in `cat ~/scripts/servers.txt` do
ssh -i ~/.ssh/yourkey.pem $SERVER df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do
echo $output
usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
partition=$(echo $output | awk '{ print $2 }' )
if [ $usep -ge $ALERT ]; then
echo "Running out of space \"$partition ($usep%)\" on $SERVER as on $(date)" | 
mail -s "Alert: Almost out of disk space $usep" $ADMIN
fi
done done