#!/bin/bash

# allow current user to run file
export PULSE_RUNTIME_PATH="/run/user/$(id -u)/pulse/"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# helper function to get values from .json files
getJSON(){
    [ ! -f times.json ] && source setTimes.sh
    echo $(jq -r .$1 $2.json)
}

# check if it's now daytime 
camSelector(){
    now=$(date +%s)
    if [ $now -gt $(date --date "$(getJSON "sunrise" "times") $(localtime\:%d/%m/%y)" +%s) ] && [ $now -lt $(date --date "$(getJSON "sunset" "times") $(localtime\:%d/%m/%y)"  +%s) ]
    then
        echo "day"
    else
        echo "night"
    fi
}

startStream(){
    # decide which camera 
    cam="cameras.$(camSelector)"

    #start new ffmpeg and write to currentCam.txt if it was successful
    $(
        /usr/bin/ffmpeg -f  \
        -i $(getJSON $cam".micInput" "config") \
                -c:a aac \
                -c:v $(getJSON $cam".recordFormat" "config") -video_size $(getJSON $cam".resolution" "config") \
        -i /dev/video"$(getJSON $cam".sourceNum" "config")" \
                -hide_banner -loglevel $(getJSON "logLevel" "config") \
                -c:v libx264 -preset ultrafast -threads 0 -profile:v high -bf 2 -g 12 -b:v $(getJSON "stream.bitrate" "config") -pix_fmt yuv420p \
                -vf "drawtext=fontfile=LDFComicSans.ttf: text='$(getJSON "stream.caption" "config") %{localtime\:%T\ %d/%m/%y}': fontcolor=white: box=1: boxcolor=black: x=(w-text_w)/2:y=h-th-10" \
        -f flv $(getJSON "stream.server" "config") & 
        sleep 5 && pgrep ffmpeg && printf $(camSelector) > currentCam.txt &
    )
    exit
}

init(){
    # if there's no cam running, start one
    if [ -z $(pgrep "ffmpeg") ] 
    then
        startStream
    # otherwise, if it's the wrong cam, kill it
    elif [ $(<currentCam.txt) != $(camSelector) ]
    then
        $(pkill "ffmpeg" && > currentCam.txt)
    fi
}
init
