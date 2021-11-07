#!/bin/bash

# Check for file, and error out if it exists
if [ -f ~/.my.cfg ]; then
  echo "[ERROR] ~/.my.cfg file exists! Aborting..."
  exit 1
fi

cp my.cfg ~/.my.cfg
chmod 600 ~/.my.cfg
