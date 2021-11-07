#!/bin/bash

# This script generates SQL commands to create the database and tables.
# The SQL commands are written to the file "CreateTables.sql" in the current directory.

# create_table_sql() {
#     echo "CREATE TABLE $1 (
#         id INTEGER PRIMARY KEY AUTOINCREMENT,
#         $2
#     );" >> $file
# }

createRandFloat(){
  # Generate a random float between min and max 4 byte float
  # $1: min
  # $2: max
  min=$1
  max=$2
  # Generate a random float between min and max [COPILOT CODE]
  # The formula is:
  #   rand = (max - min) * rand + min
  # where rand is a random float between 0 and 1
  rand=$(echo "scale=4; ($max - $min) * $RANDOM / 32768 + $min" | bc)
  echo $rand

  # # FLOAT MAX_VALUE
  # fltMaxVal=$(echo "scale=2; $RANDOM / 32767" | bc)


  # # FLOAT MIN_VALUE
  # fltMinVal=$(echo "scale=2; $RANDOM / 32767" | bc)

  # # MySql Float Min Signed: -3.4028235e+38 == -340282346600000000000000000000000000000
  # # MySql Float Max Signed: -1.17549435e-38 == -0.0000000000000000000000000000000000000117549435

}


# Create the database
function createDatabase() {
  dbname="db_"$1

  echo "-- AS ROOT:" >> $2
  echo "-- --------" >> $2
  echo "-- CREATE DATABASE $dbname;" >> $2
  #echo "-- CREATE DATABASE IF NOT EXISTS $dbname;" >> $file
  echo "" >> $2
  echo "-- USE $dbname;" >> $2

  echo "-- GRANT ALL PRIVILEGES ON $dbname.* TO '$3'@'localhost';" >> $2 #IDENTIFIED BY '$dbname';" >> $2

  echo "" >> $2
}

function createTableLongtext() {
  dbname="db_"$1
  tableName="tbl_"$1
  file="$2"

  echo "USE $dbname;" >> $2
  echo "" >> $2
  #https://www.mysqltutorial.org/mysql-uuid/
  echo "CREATE TABLE IF NOT EXISTS $tableName (
      id BINARY(16) PRIMARY KEY,
      name LONGTEXT(255)
);" >> $2

  echo "" >> $2
}

function createTableFloat() {
  dbname="db_"$1
  tableName="tbl_"$1
  file="$2"

  echo "USE $dbname;" >> $2
  echo "" >> $2

  echo "CREATE TABLE IF NOT EXISTS $tableName (
      id BINARY(16) PRIMARY KEY,
      value FLOAT(30,6)
);" >> $2

  echo "" >> $2
}


function insertIntoTable() {
  tableName="tbl_"$1
  file="$2"
  #echo "INSERT INTO $tableName (id, name) VALUES (1, 'John');" >> $file

  #https://www.mysqltutorial.org/mysql-uuid/
  # INSERT INTO customers(id, name)
  # VALUES(UUID_TO_BIN(UUID()),'John Doe'),
  #       (UUID_TO_BIN(UUID()),'Will Smith'),
  #       (UUID_TO_BIN(UUID()),'Mary Jane');

}

if [ $# -ne 1 ]; then
  echo "Usage: $0 <action>"
  echo "  action: create | insert"
  exit 1
fi

user="bigdata"
file="CreateTables.sql"
rm -f $file
touch $file

# createRandFloat 
createDatabase "test" "$file" "$user"
createTableFloat "test" "$file"
