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
  echo "CREATE DATABASE IF NOT EXISTS $dbname;" >> $file
  echo "" >> $file
  echo "USE $dbname;" >> $file
  # CREATE TABLE IF NOT EXISTS `test` (
  #      `test` float NOT NULL
  # ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

  # INSERT INTO `test`(`test`) VALUES (16777225)

  # SELECT * FROM `test`
  echo "" >> $file
}

function createTableLongtext() {
  tableName="tbl_"$1
  file="$2"
# CREATE TABLE customers (
#     id BINARY(16) PRIMARY KEY,
#     name VARCHAR(255)
# );

  echo "CREATE TABLE IF NOT EXISTS $tableName (
      id BINARY(16) PRIMARY KEY,
      name LONGTEXT(255)
  );" >> $file

  echo "" >> $file
}

function createTableFloat() {
  tableName="tbl_"$1
  file="$2"
# CREATE TABLE customers (
#     id BINARY(16) PRIMARY KEY,
#     name VARCHAR(255)
# );

  echo "CREATE TABLE IF NOT EXISTS $tableName (
      id BINARY(16) PRIMARY KEY,
      value FLOAT(30,6)
  );" >> $file

  echo "" >> $file
}

file="CreateTables.sql"
rm -f $file

# createRandFloat 
createDatabase "test" "$file"
createTableFloat "test" "$file"
