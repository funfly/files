#!/bin/bash

netstat -an|grep -q ':3000' && echo "svn is runing" > /dev/null || /usr/local/svn/bin/svnserve -d --listen-port 3000 -r /usr/local/svndata