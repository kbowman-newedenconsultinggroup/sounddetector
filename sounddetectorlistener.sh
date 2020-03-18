#!/bin/bash
##########################
# MQTT Shell Listen & Exec
# stolen from Chev_603 (darkerego) here:
# https://unix.stackexchange.com/questions/188525/how-to-subscribe-a-bash-script-as-a-mqtt-client/274224#274224

host=`grep mqtthost ./secrets.py | awk '{{gsub("\047","",$3)}; print $3}'`
user=`grep mqttuser ./secrets.py | awk '{{gsub("\047","",$3)}; print $3}'`
pass=`grep mqttpass ./secrets.py | awk '{{gsub("\047","",$3)}; print $3}'`


clean="out cmds";p="backpipe";pid=$(cat pidfile)
ctrl_c() {
  echo "Cleaning up..."
  rm -f $p;rm "$clean";kill $pid 2>/dev/null
  if [[ "$?" -eq "0" ]];
  then
     echo "Exit success";exit 0
  else
     exit 1
  fi
}

listen(){
([ ! -p "$p" ]) && mkfifo $p
(mosquitto_sub -h $host -t sounddetector/cmds -u $user -P $pass >$p 2>/dev/null) &
echo "$!" > pidfile
while read line <$p
do
  echo $line > cmds
  if grep -q "quit" cmds; then
    (rm -f $p;rm $clean;kill $pid) 2>/dev/null
    break
  else
    (bash cmds &)
  fi
done
}

trap ctrl_c INT
listen
