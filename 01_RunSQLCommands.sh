#!/bin/bash

# if [ ! -f ~/.my.cfg ]; then
#   echo "[ERROR] ~/.my.cfg DOES NOT exist! Aborting..."
#   exit 1
# fi

mysql --defaults-file=my.cfg -h localhost < CreateTables.sql
