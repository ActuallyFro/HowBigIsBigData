#!/bin/bash
while true; do
  clear
  amnt=`cat temp.md |wc -l`

  percentTemp=$(($amnt*1000/1000000))

  strLen="${#percentTemp}"
  pointPos=$(($strLen-1))

  percent="${percentTemp:0:$pointPos}.${percentTemp:$pointPos}"

  echo "$amnt/1000000 ($percent%)"
  sleep 4
done
