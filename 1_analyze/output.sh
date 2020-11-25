#!/bin/bash

root=~/bot/1_analyze
data=$root/../data

for datum in "$@"
do
 ./bin/create_outputs "$datum" > "../data/output/$datum.txt"
 
  convert -size 960x240 xc:black  \
    -font "Noto-Mono" -pointsize 18 -fill white \
    -draw "text 0,10 '$(cat $data/output/$datum.txt)'" -monochrome ${data}/output/$datum.png 
done 

