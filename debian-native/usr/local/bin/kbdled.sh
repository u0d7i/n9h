#!/bin/bash

# cfg
STEP=20
STD=50

getbr(){
  BR=$(cat /sys/class/leds/lp5523\:kb1/brightness)
  echo $BR
}

setbr(){
  BR=$1
  for n in 1 2 3 4 5 6
  do
    echo $BR > /sys/class/leds/lp5523\:kb${n}/brightness
  done
}

decbr(){
  if [ $(getbr) -lt $STEP ]; then
    setbr 0
  else
    setbr $(( $(getbr) - $STEP ))
  fi
}

encbr(){
  if [ $(( $(getbr) + $STEP )) -gt 255 ]; then
    setbr 255
  else
    setbr $(( $(getbr) + $STEP ))
  fi
}

case $1 in
  on)
    setbr $STD;;
  off)
    setbr 0;;
  show)
    getbr;;
  +)
    encbr;;
  -)
    decbr;;
  [0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-5][0-5])
    setbr $1;;
  *)
    echo "usage: $(basename $0) < on | off | show | + | - | 0-255 >"
    ;;
esac

