#!/bin/bash

root=~/bot/3_output
data=${root}/../data

echo -n " | output: "

./output.sh > $data/state/.output.txt 


cd $data/state/
mv .output.txt output.txt

convert \
  -size 3840x2160 \
  xc:black \
  \( -gravity center \
  -background black \
  -size 3840x2110 \
  -font FreeMono \
  -pointsize 25 \
  -fill "#00FF00"  \
  pango:@output.txt \) \
  -gravity center \
  -composite \
  .output_4k_black.bmp 
mv .output_4k_black.bmp output_4k_black.bmp

convert \
  -size 1920x1080 \
  xc:black \
  \( -gravity center \
  -background black \
  -size 1920x1055 \
  -font FreeMono \
  -pointsize 12 \
  -fill "#00FF00"  \
  pango:@output.txt \) \
  -gravity center \
  -composite \
  .output_1080p_black.bmp 
mv .output_1080p_black.bmp output_1080p_black.bmp

echo "*"

#convert \
#  -gravity center \
#  -background black  \
#  -font FreeMono \
#  -pointsize 20 \
#  -fill green \
#  pango:@output.txt \
#  .output_4k.bmp 
