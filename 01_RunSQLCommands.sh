#!/bin/bash

if [ -z "$(which pv)" ]; then
  echo "[ERROR] pv is not installed"
  exit 1
fi


if [ $# -ne 1 ]; then
  echo "Usage: $0 <action>"
  echo "  action: create | insert "
  exit 1
fi

file="InsertTables.sql"

#It's MORE likely to run insert more often than create
# if [ "$1" == "insert" ]; then
if [ "$1" == "create" ]; then
  file="CreateTables.sql"
fi

# nameDB="test"

# if [ ! -f ~/.my.cfg ]; then
#   echo "[ERROR] ~/.my.cfg DOES NOT exist! Aborting..."
#   exit 1
# fi

if [ ! -f "$file" ]; then
  echo "[ERROR] $file DOES NOT exist! Aborting..."
  exit 1
fi

# # WORKS
# mysql --defaults-file=my.cfg -h localhost < CreateTables.sql

# https://dba.stackexchange.com/questions/17367/how-can-i-monitor-the-progress-of-an-import-of-a-large-sql-file
# pv file-name.sql | mysql -u root -pPass <DataBaseName>
pv "$file" | mysql --defaults-file=my.cfg -h localhost

# pv CreateTables.sql | mysql --defaults-file=my.cfg -h localhost "db_"$nameDB
