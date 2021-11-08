#!/bin/bash

#if not $1, then exit
if [ -z "$1" ]; then
    echo "No input file specified"
    exit 1
fi

rm -f temp.md
while IFS= read -r line; do 
  echo $line | cut -c1 >> temp.md
done < "$1"

tail -n +3 temp.md > FirstChars.md #remove first two lines

#cat FirstChars.md, sort, uniq count and print
cat FirstChars.md | sort | uniq -c | sort -nr

rm temp.md
rm FirstChars.md


#Manually works:
  # rm -f temp.md; while IFS= read -r line; do echo $line | cut -c1 >> temp.md; done < new.md
  # tail -n +3 temp.md > FirstChars.md
  # cat FirstChars.md | sort | uniq -c | sort -nr