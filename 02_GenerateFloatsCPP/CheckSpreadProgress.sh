#!/bin/bash
while true; do
  clear
  amnt=`cat temp.md |wc -l`

  percentTemp=$(($amnt*1000/1000000))

  strLen="${#percentTemp}"
  pointPos=$(($strLen-1))

  #https://unix.stackexchange.com/questions/369818/how-to-insert-a-string-into-a-text-variable-at-specified-position
  percent="${percentTemp:0:$pointPos}.${percentTemp:$pointPos}"

  echo "$amnt/1000000 ($percent%)"
  sleep 4
done
