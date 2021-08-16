#!/bin/sh

#####################################################################################################

## mail -s "Some random subject" -a "From: some@domain.com" to@domain.com

## Tested and successfully Run on AWS server : need to install mailutils on server
## For mail send :
##  apt update
## apt install mailutils  -- internet site ---mail.gmail.com
## nano /etc/postfix/main.cf ------ inet_interfaces = loopback-only --- myhostname=mail.example.com
## service postfix restart
## test email : echo "This email confirms that Postfix is working" | mail -s "Testing Posfix" emailuser@example.com

######################################################################################################

df -Ph | grep  '/dev/nvme0n1p1' | awk '{ print $5,$1 }' | while read output;
do
  echo $output
  used=$(echo $output | awk '{print $1}' | sed s/%//g)
  partition=$(echo $output | awk '{print $2}')
  if [ $used -ge 60 ]; then
  echo "The partition \"$partition\" on $(hostname) has used $used% at $(date)" | mail -s "Disk Space Alert: $used% Used On dev-Server" -a "From: example@gmail.com" kexample1@gmail.com
  fi
done