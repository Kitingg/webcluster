#!/bin/bash
t1=$(ifconfig | grep -o eth0:0)
t2='eth0:0'

if [ "$t1" = "$t2" ]; then
  echo 1
else
  echo 0
fi

exit
