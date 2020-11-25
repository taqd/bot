#!/bin/bash

root=~/bot/2_stream
data=$root/../data

#BITRATE="2500k" # Bitrate of the output video
#FPS="30" # FPS video output
#QUAL="high" # FFMPEG quality preset
#
#
#
#KEY="wu7r-b0wv-c4r9-u86k-e47s" # Stream name/key
#FRAMERATE="10"
#
#YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2" # Youtube RTMP base URL
#
#    ffmpeg -f image2 \
#      -stream_loop -1 \
#      -re \
#    	-i "$IMAGE" \
#    	-framerate "$FRAMERATE" \
#    	-s "$SIZE" \
#    	-vcodec libx264 \
#    	-pix_fmt yuv420p \
#    	-f flv \
#      "$YOUTUBE_URL/$KEY"

#VBR="2500k"                                    # Bitrate de la vidéo en sortie
#FPS="30"                                       # FPS de la vidéo en sortie
#QUAL="medium"                                  # Preset de qualité FFMPEG
#YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"  # URL de base RTMP youtube
#
#
#ffmpeg \
#    -f image2 -stream_loop -1 -re -i "$SOURCE" -deinterlace \
#    -vcodec libx264 -pix_fmt yuv420p -preset $QUAL -r $FPS -g $(($FPS * 2)) -b:v $VBR \
#    -acodec libmp3lame -threads 6 -bufsize 512k \
#    -f flv "$YOUTUBE_URL/$KEY"
#
      #${data}/state/stream.mp4
#ffmpeg -re -loop 1 -i ${data}/state/stream.png -r 1 -s 3840x2160 \
#  -vcodec libx264 -crf 0 -pix_fmt yuv420p -f flv ${data}/state/stream.mp4

SIZE="3840x2160"
#SIZE="1920x1080"
VBR="3200k"
FPS="30"
QUAL="fast"
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"
YOUTUBE_KEY="wu7r-b0wv-c4r9-u86k-e47s" # Stream name/key
VIDEO_SOURCE="${data}/stream/stream1.png" #Picture
 
ffmpeg \
 -stream_loop -1 \
 -f image2 \
 -s $SIZE \
 -i "$VIDEO_SOURCE" \
 -re \
 -f lavfi \
 -i anullsrc \
 -c:v libx264 \
 -g 60 \
 -x264opts no-scenecut \
 -preset ultrafast \
 -crf 100 \
 -pix_fmt yuv420p \
 -r 20 \
 -f flv \
 $YOUTUBE_URL/$YOUTUBE_KEY

 #-profile:v high \
#VBR="3200k"
#FPS="20"
#QUAL="ultrafast"
#YOUTUBE_URL=" rtmp://a.rtmp.youtube.com/live2"
#YOUTUBE_KEY="wu7r-b0wv-c4r9-u86k-e47s" # Stream name/key
#VIDEO_SOURCE="out.png" #"${data}/stream/stream1.png" #Picture
# 
#ffmpeg \
# -loop 1 \
# -re \
# -framerate $FPS \
# -i "$VIDEO_SOURCE" \
# -f lavfi \
# -i anullsrc \
# -thread_queue_size 512 \
# -c:v libx264 -tune stillimage -pix_fmt yuv420p -preset $QUAL -r $FPS -g $(($FPS *2)) -b:v $VBR \
# -threads 32 -bufsize 512k -pix_fmt yuv420p \
# -f flv $YOUTUBE_URL/$YOUTUBE_KEY
