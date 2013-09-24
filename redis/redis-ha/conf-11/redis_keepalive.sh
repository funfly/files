#!/bin/bash

ALIVE=$(/usr/local/redis/src/redis-cli -h 192.168.56.11 -p 6379 PING)
if [ "$ALIVE" == "PONG" ]; then
    echo $ALIVE
    exit 0
    else
    echo $ALIVE
    killall -9 keepalived
    service network restart
    exit 1
fi