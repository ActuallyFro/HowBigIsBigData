#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <action>"
  echo "  action: create | insert | connect "
  echo "  count | list | size | size-tables | erase | erase-longtext"
  exit 0
fi

if [ -z "$(which mysql)" ]; then
  echo "[ERROR] mysql is not installed!"
  exit 2
fi

# FOR UUIDS! https://remarkablemark.org/blog/2020/05/21/mysql-uuid-bin/

file="InsertTables.sql" #Runs the .sql that LOADS generateRandFloat.csv

#It's MORE likely to run insert more often than create
# if [ "$1" == "insert" ]; then
if [ "$1" == "connect" ]; then
  mysql --defaults-file=my.cfg -h localhost
  echo "[RunCommands] Connect is Fin!"
  exit 0

elif [ "$1" == "count" ] || [ "$1" == "list" ] || [ "$1" == "size" ] || [ "$1" == "erase" ]  || [ "$1" == "erase-longtext" ] || [ "$1" == "size-tables" ]; then
  nameTest="test"
  dbname="db_"$nameTest
  tableName="tbl_"$nameTest

  cmd_to_send=""
  cmd_use="USE $dbname;"
  cmd_add=""

  if [ "$1" == "list" ]; then
    cmd_add="SELECT * FROM $tableName;"

  elif [ "$1" == "count" ]; then
    cmd_add="SELECT COUNT(*) FROM $tableName;"

  elif [ "$1" == "size" ]; then
    # https://stackoverflow.com/questions/1733507/how-to-get-size-of-mysql-database
    cmd_add="SELECT table_schema AS \"Database\", SUM(data_length + index_length) / 1024 / 1024 AS \"Size (MB)\" FROM information_schema.TABLES GROUP BY table_schema"

  elif [ "$1" == "size-tables" ]; then
    #https://chartio.com/resources/tutorials/how-to-get-the-size-of-a-table-in-mysql/
    cmd_add="SELECT TABLE_NAME AS \`Table\`, ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024) AS \`Size (MB)\` FROM information_schema.TABLES WHERE TABLE_SCHEMA = \"$dbname\" ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC;"

  elif [ "$1" == "erase" ] || [ "$1" == "erase-longtext" ]; then
    if [ "$1" == "erase-longtext" ]; then
      tableName="tbl_"$nameTest"_longtext"
    fi
    cmd_add="DELETE FROM $tableName;"
  fi

  cmd_to_send="$cmd_use $cmd_add"

  echo "[RunCommands] Sending Cmd: <$cmd_to_send>"

  mysql --defaults-file=my.cfg -h localhost -e "$cmd_to_send"
  echo "[RunCommands] Connect is Fin!"
  exit 0


elif [ "$1" == "create" ]; then
  file="CreateTables.sql"
fi

if [ ! -f "$file" ]; then
  echo "[ERROR] $file DOES NOT exist! Aborting..."
  exit 3
fi

if [ -z "$(which pv)" ]; then
  echo "[ERROR] pv is not installed"
  exit 4
fi

# # WORKS
# mysql --defaults-file=my.cfg -h localhost < CreateTables.sql

# https://dba.stackexchange.com/questions/17367/how-can-i-monitor-the-progress-of-an-import-of-a-large-sql-file
# pv file-name.sql | mysql -u root -pPass <DataBaseName>
# pv "$file" | mysql --defaults-file=my.cfg -h localhost
#^---- likely DOES NOT work, because this is based on the INSERT vs. LOAD FILE concept

# pv CreateTables.sql | mysql --defaults-file=my.cfg -h localhost "db_"$nameDB

if [ "$1" == "create" ]; then
  pv "$file" | mysql --defaults-file=my.cfg -h localhost
  echo "[RunCommands] Done creating!"

else
  generatedFloatsFile="generateRandFloat.csv"
  newCSVFile=`cat InsertTables.sql | sed "s/INFILE /###\n/g" | sed "s/INTO/\n###/g" | grep -v "###" | tr -d "'"`
  echo "[RunCommands] Updating .csv ("$newCSVFile")"
  #sudo rm -f "$newCSVFile" #--it is just copied over... :-/
  #sudo cp "$generatedFloatsFile" "$newCSVFile" #Assumes mysql is still sudo blocked...
  cp "$generatedFloatsFile" "$newCSVFile" #yeah ... gonna (1) sudo chown `whoami` /var/lib/mysql-files && (2) sudo chmod -R a+rwx /var/lib/mysql-files

  if [ ! -f "$generatedFloatsFile" ]; then
    echo "[ERROR] $generatedFloatsFile DOES NOT exist! Aborting..."
    exit 5
  fi

  # check if newCSVFile exists, abort if not
  if [ ! -f "$newCSVFile" ]; then
    echo "[ERROR] $newCSVFile DOES NOT exist! Aborting..."
    exit 6
  fi
  cmd_to_send=`cat $file`

  echo "[RunCommands] Sending Cmd: <$cmd_to_send>"

  mysql --defaults-file=my.cfg -h localhost -e "$cmd_to_send"
  # sudo rm -f "$newCSVFile"
  rm -f "$newCSVFile"

  echo "[RunCommands] Done inserting!"

fi
