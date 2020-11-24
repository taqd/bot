#!/bin/bash

root=~/bot/1_analyze
data=$root/../data

for datum in "$@"
do
 ./bin/create_outputs "$datum" > "../data/output/$datum.txt"
 
  convert -size 880x540 xc:black  \
    -font "Noto-Mono" -pointsize 22 -fill green \
    -draw "text 0,10 '$(cat $data/output/$datum.txt)'" -trim ${data}/output/$datum.png 
done 

