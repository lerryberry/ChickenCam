# ChickenCam
24 hour livestream of our backyard chickens with day and night cams! Written for Raspberry Pi 3B.

## Architecture
All user configurations are stored in `config.json`, all sunrise and sunset times are stored in `times.json`, which is the interface between `setTimes.sh` and `stream.sh`.

## setTimes.sh
Runs every morning at 2am, and gets the gps coordinates set `config.json`, then requests the local sunrise and sunset times from the `api.sunrisesunset.io`, and stores the full response into `times.json`.

*Cron job*
``` 0 2 * * * cd /home/<user>/ChickenCam && ./setTimes.sh 2>> /home/<user>/ChickenCam/err.log```

## stream.sh
Runs every minute, and starts a new streaming process if one isn't already running. Otherwise, it kills the process if it's the wrong one by re-calculating which camera the correct one is, and comparing the calculated value to the stored value in `currentCam.txt`. If the stream was killed, it will be started again when the script next runs in under 1 minute.

*Cron job*
```* * * * * cd /home/<user>/ChickenCam && ./stream.sh 2>> /home/<user>/ChickenCam/err.log```

## Setup / Dependencies
- Install each of the following:
```ffmpeg, jq & pulseaudio```
- make scripts executable 
```chmod +x stream.sh```
```chmod +x setTimes.sh```
- Plug in your cameras and update `config.json` accordingly, infromation can be found by running: ```v4l2-ctl --list-devices```
