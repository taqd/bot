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
  -fill green  \
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
  -fill green  \
  pango:@output.txt \) \
  -gravity center \
  -composite \
  .output_1080p_black.bmp 
mv .output_1080p_black.bmp output_1080p_black.bmp


echo "*"

#convert \
#  -gravity east \
#  -background black  \
#  -font FreeMono \
#  -pointsize 25 \
#  -fill green \
#  pango:@output.txt \
#  .output_4k_black.bmp 


#
#convert \
#  -size 3200x1440 \
#  -gravity center \
#  -background black  \
#  -font FreeMono \
#  -pointsize 16 \
#  -fill green \
#  pango:@output.txt \
#  .output_20x9_black.bmp 
#
#convert \
#  -size 3840x2160 \
#  xc:white \
#  \( -gravity center \
#  -background white \
#  -size 3584x1763 \
#  -font FreeMono \
#  -pointsize 20 \
#  -fill black  \
#  pango:@output.txt \) \
#  -gravity center \
#  -composite \
#  .output_4k_white.bmp 
#
#convert \
#  -size 1920x1080 \
#  xc:white \
#  \( -gravity center \
#  -background white \
#  -size 1792x944 \
#  -font FreeMono \
#  -pointsize 10.5 \
#  -fill black  \
#  pango:@output.txt \) \
#  -gravity center \
#  -composite \
#  .output_1080p_white.bmp 
#
#convert \
#  -size 3200x1440 \
#  -gravity center \
#  -background white  \
#  -font FreeMono \
#  -pointsize 16 \
#  -fill black \
#  pango:@output.txt \
#  .output_20x9_white.bmp 
#
#mv .output_20x9_black.bmp output_20x9_black.bmp
#mv .output_4k_white.bmp output_4k_white.bmp
#mv .output_1080p_white.bmp output_1080p_white.bmp
#mv .output_20x9_white.bmp output_20x9_white.bmp
#

#convert \
#  -gravity center \
#  -background black  \
#  -font FreeMono \
#  -pointsize 20 \
#  -fill green \
#  pango:@output.txt \
#  .output_4k.bmp 




#  -size 1792x881 \
#convert \
#  -gravity center \
#  -background black  \
#  -font FreeMono \
#  -pointsize 10.5 \
#  -fill green \
#  pango:@output.txt \
#  .output_1080p.bmp 


#convert -background black \
#  -fill green \
#  -font "DejaVu-Sans-Mono" \
#  -pointsize 26 \
#  -geometry 3840x2160 \
#  pango:@output.txt \
#  image_tmp.png 


  #-draw "text 10,30 'pango:@$(cat output.txt)'" \

#convert -size 3840x2160 xc:black  \
#    -font "DejaVu-Sans-Mono" -pointsize 26 -gravity center -fill green \
#    -draw "text 10,30 '$(cat output.txt)'" -trim image_tmp.png 
#convert -size 3840x2160 xc:black  \
#    -font "FreeMono" -pointsize 26 -gravity center -fill green \
#    -draw "text 10,30 '$(cat output.txt)'" -trim image_tmp.png 


#cat output.txt | convert -page 3840x2160+0+0 -font "DejaVu-Sans-Mono" -style Normal -background black \
# -undercolor black -fill green -pointsize 26 text:- +repage -background black -flatten image_tmp.png

#convert -background black -density 196 -resample 72 -unsharp 0x.5 -font "Courier" \
#  text: output.txt -trim +repage -bordercolor white -border 3 image_tmp.png
#ansilove -c 227 output.txt -m transparent -o image.png -r -f terminus -q 
#convert image.png -background "#000000" -flatten image_tmp.png

