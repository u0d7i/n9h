#!/bin/bash

LED=/sys/class/backlight/acx565akm/brightness
# defaults
# FIXME: save/restore values
SL=100
KL=50

STATUS=$(cat $LED)
# FIXME: check for lid open/close

if [ "$STATUS" != "0" ]; then
  # "On"
  echo 0 > $LED
  for n in 1 2 3 4 5 6
  do
    echo 0 > /sys/class/leds/lp5523\:kb${n}/brightness
  done
else
  # "Off"
  echo $SL > $LED
  for n in 1 2 3 4 5 6
  do
    echo $KL > /sys/class/leds/lp5523\:kb${n}/brightness
  done
fi
