#!/bin/bash

root=~/bot/3_output
data=$root/../data

YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"

SIZE="1920x1080"
YOUTUBE_KEY="j6tc-mgqh-wxgk-k73t-czuz"
VIDEO_SOURCE="${data}/state/output_1080p_black.bmp"
 
ffmpeg \
 -stream_loop -1 \
 -f image2 \
 -s $SIZE \
 -i "$VIDEO_SOURCE" \
 -re \
 -f lavfi \
 -i anullsrc \
 -c:v libx264 \
 -g 25 \
 -x264opts no-scenecut \
 -preset ultrafast \
 -tune stillimage \
 -crf 10 \
 -pix_fmt yuv420p \
 -r 25 \
 -f flv \
 $YOUTUBE_URL/$YOUTUBE_KEY
