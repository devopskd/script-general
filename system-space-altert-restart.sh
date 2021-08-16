#FILESYSTEM=/ # or whatever filesystem to monitor
CAPACITY=90 # delete if FS is over 95% of usage
ADMIN=kush210@gmail.com
TOT=$(df -k / | tail -1 | awk '{print $5}')
echo $TOT
if [ $(df -k / | awk '{ gsub("%",""); capacity = $5 }; END { print capacity }') -gt $CAPACITY ]
then
echo "Running out of space $TOT on $(hostname) as on $(date)" |
    mail -s "Alert: Almost out of disk space $TOT" $ADMIN
sleep 6s
reboot
fi