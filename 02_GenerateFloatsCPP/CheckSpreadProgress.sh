#!/bin/bash
while true; do
  clear
  amnt=`cat temp.md |wc -l`

  percentTemp=$(($amnt*1000/1000000))
  percent="${percentTemp:0:1}.${percentTemp:1}"

  echo "$amnt/1000000 ($percent%)"
  sleep 4
done
