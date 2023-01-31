# ChickenCam
24 hour livestream of our backyard chickens with day and night cams! Written for Raspberry Pi 3B.

## Architecture
All user configurations are stored in `config.json`, all sunrise and sunset times are stored in `times.json`, which is the interface between `setTimes.sh` and `stream.sh`.

## setTimes.sh
Runs every morning at 2am, and gets the gps coordinates set `config.json`, then requests the local sunrise and sunset times from the `api.sunrisesunset.io`, and stores the full response into `times.json`.

*Cron job*

```* * * * * cd /home/<user>/Scripts/ChickenCam && ./stream.sh 2>> /home/<user>/Scripts/ChickenCam/err.log```

## stream.sh
Runs every minute, and starts a new streaming process if one isn't already running. Otherwise, it checks the existing stream is the correct one by calculating whether it's currently daytime or nightime, and comparing this calculated value to the value stored when the last stream started in `currentCam.txt`, which is either "day", or "night". If the comparison fails, and it's the wrong camera, then it kills any active streaming process, if it's the right camera, it does nothing and exits the script. The right camera will be started when the script next runs again in under 1 minute.

*Cron job*

```* * * * * cd /home/<user>/Scripts/ChickenCam && ./stream.sh 2>> /home/<user>/Scripts/ChickenCam/err.log```

## Setup / Dependencies
- Install each of the following:
```ffmpeg, jq & pulse```
- make scripts executable 
```chmod +x stream.sh```
```chmod +x setTimes.sh```
- Plug in your cameras and update config.json accordingly, infromation can be found by running
```for d in /dev/video* ; do echo $d ; v4l2-ctl --device=$d -D --list-formats  ; echo '===============' ; done
/dev/video0```
