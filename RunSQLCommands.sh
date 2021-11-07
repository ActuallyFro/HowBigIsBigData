#!/bin/bash

if [ ! -f ~/.my.cfg ]; then
  echo "[ERROR] ~/.my.cfg DOES NOT exist! Aborting..."
  exit 1
fi

mysql -h localhost < CreateTables.sql

#Alternatively: --defaults-extra-file=my.cfg

