# ChickenCam
24 hour livestream of our backyard chickens!

*setTimes.sh*
A cron job is to run setTimes.sh every morning at 2am, this will get today's local sunrise and sunset times, and store them in time.json

*stream.sh*
A cron job is to run this script every minute, this will either do nothing (if the right stream is on), start a new stream if there's not one running, or kill a stream (if it's the wrong one).
