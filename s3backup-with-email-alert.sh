#!/bin/bash

#Admin="kaushik@codezeros.com"

timestamp=$(date +"%F %r")

copyloc="/home/dailybackup"

backlogfile="/home/dailybackup/log"

#email_sub="Amazon s3 Backup Status"

#email_msgs="Backup Successful"

#email_msgf="Backup Failed"

`aws s3 cp -r $copyloc s3://prezents3`

if [ $? -eq 0 ];then
   echo "Backup Completed Successfully at $timestamp"  >> "$backlogfile"
   echo "$email_msgs" | mail -s "$email_sub" -r "$(hostname)<server@yourserver.com>" $Admin
else
   echo "Backup Failed at $timestamp"  >> "$backlogfile"
   echo "$email_msgf" | mail -s "$email_sub" -r "$(hostname)<server@yourserver.com>" $Admin
fi
