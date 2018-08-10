#!/usr/bin/env bash

echo "Sleeping 30 seconds to let the devices power on"
for i in {1..30}
do
   echo -n "."
done


while :
do
    echo "Cleaning up previous segments..."
	rm -rf /home/pi/video/* 
    echo "Starting stream..."
    sudo ffmpeg -loglevel debug -y \
        -f video4linux2 -s 640x480 -framerate 10 \
        -thread_queue_size 1024 -i /dev/video0 \
        -itsoffset 2 -f alsa -ac 1 -thread_queue_size 1024 \
        -i hw:2 -c:v h264_omx -c:a aac -b:a 128k -ar 44100 \
        -vf drawtext="fontsize=15:fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf:\
        timecode='00\:00\:00\:00':rate=10:text='TCR\:':fontsize=12:fontcolor='white':\
        boxcolor=0x000000AA:box=1:x=10:y=10" \
        -f segment \
        -segment_time 10 \
        -segment_format mpegts \
        -segment_list "/home/pi/video/index.m3u8" \
        -segment_list_size 10 \
        -segment_wrap 20 \
        -segment_format mpegts \
        -segment_list_flags live \
        -segment_list_type m3u8 \
        "/home/pi/video/fileSequence%d.ts"
    echo "Return code $?"
	sleep 1
done

#sudo rm -f /home/pi/out.log /home/pi/error.log;/home/pi/start_streaming.sh > /home/pi/out.log 2> /home/pi/error.log &
# dwc_otg.fiq_fsm_mask=0x3 



#-vf drawtext="fontsize=15:fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf:\
        timecode='00\:00\:00\:00':rate=10:text='TCR\:':fontsize=72:fontcolor='white':\
        boxcolor=0x000000AA:box=1:x=10:y=10" \
