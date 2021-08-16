
#!/bin/bash

#going to root directory
#cd /home/ubuntu
cd /home/gitbackup

#taking date value for naming system
dt=gitbkup-$(date +"%d-%m-%y-%H:%M:%S").zip
#creating tar archive
zip -r $dt /var/www/html/git

#Uploading tar archive to S3 bucket
aws s3 cp  $dt s3://czs-git-backup

rm -rf $dt

#writing log
echo "wrote $dt" >> /var/log/gitbkup/gbkup.log
