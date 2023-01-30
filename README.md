# ChickenCam
24 hour livestream of our backyard chickens!

*setTimes.sh* is to run every morning at 2am, this will get today's local sunrise and sunset times, and store them in time.json

*stream.sh* is to run every minute, this will either do nothing (if the right camera is on at the right time), start a new stream if there's not one running, or kill a stream (if it's daytime and the nighttime camera is on, or vice versa).
