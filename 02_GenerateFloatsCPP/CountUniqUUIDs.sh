#!/bin/bash
cat ../generateRandFloat.csv | grep -v "\-\-" | tr "," "\n" | grep -v "\." | sort | uniq -c | wc -l
