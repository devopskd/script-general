#!/bin/bash

#going to root directory

cd /home/git-server/Documents

#taking date value for nameing system
dt="$(date '+%Y-%m-%d').tar.gz"

#creating tar archive
tar -zcvf $dt /home/git-server/Documents/Repository/*

#Uploading tar archive to S3 bucket
aws s3 cp  $dt s3://wc-repo-backup-1

rm -rf $dt

#writing log 
echo "wrote $dt" >> /home/git-server/Documents/log/compiled.log

