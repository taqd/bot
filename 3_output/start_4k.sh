#!/bin/bash

root=~/bot/3_output
data=$root/../data

YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"

SIZE="3840x2160"
YOUTUBE_KEY="ggz6-cwcd-2aq6-xk64-dsgg"
VIDEO_SOURCE="${data}/state/output_4k_black.bmp"
  
ffmpeg \
 -stream_loop -1 \
 -f image2 \
 -s $SIZE \
 -i "$VIDEO_SOURCE" \
 -re \
 -f lavfi \
 -i anullsrc \
 -c:v libx264 \
 -g 200 \
 -x264opts no-scenecut \
 -preset ultrafast \
 -tune stillimage \
 -crf 30 \
 -pix_fmt yuv420p \
 -r 30 \
 -f flv \
 $YOUTUBE_URL/$YOUTUBE_KEY
