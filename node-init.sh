#!/bin/sh
### BEGIN INIT INFO
# Provides:          node
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# X-Interactive:     false
# Short-Description: Script to starst Appium service through node
# Description:       Start/stop Appium server on localhost 
### END INIT INFO

DESC="Start Appium server"
NAME=node
#DAEMON=

do_start()
{
   echo "starting!";
   sudo -u vagrant node /home/vagrant/appium 1>/tmp/node.log &
}

do_stop()
{
   echo "stopping!"
   # pid=$(ps -ea |grep node |cut -c 1-6)
   # kill "$pid"
   killall node
}


case "$1" in
   start)
     do_start
     ;;
   stop)
     do_stop
     ;;
   restart)
     do_stop
     do_start
     ;;
esac

exit 0
