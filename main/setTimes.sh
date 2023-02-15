#!/bin/bash

# helper function to get specific value from config.json file
getConfig(){
    echo $(jq -r .$1 config.json)
}

# fetch then store sunset & sunrise UTC times based on latitude & longitude in config.json
storeTimes(){
    #convert logLevels to curl flag
    curlLogLevel=$([ $(getConfig "logLevel") = "quiet" ] && echo "-s")
    req=$(curl $curlLogLevel "https://api.sunrisesunset.io/json?lat="$(getConfig "coordinates.lat")"&lng="$(getConfig "coordinates.lon")"")
    # only store if response body has a value
    [ ! -z "$req" ] && echo $req | jq . > times.json
}
storeTimes
