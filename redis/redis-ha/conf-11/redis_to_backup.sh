#!/bin/bash

/usr/local/redis/src/redis-cli -h 192.168.56.11 -p 6379 slaveof 192.168.56.10 6379