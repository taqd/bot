#!/bin/bash

root=~/bot/scripts
data=${root}/../data

hostname=`cat /etc/hostname`
echo -n " | sync "
cd $data
tar -caf raw.tar ./raw ./targets 
echo -n "*"
scp -q -i /home/tyler/.ssh/google_compute_engine raw.tar \
  tyler@34.82.123.49:/home/tyler/bot/data/raw_${hostname}.tar
echo -n "*"
ssh  -i /home/tyler/.ssh/google_compute_engine tyler@34.82.123.49 ./sync_me.sh > /dev/null
echo "*"
