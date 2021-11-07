#!/bin/bash

# This script generates SQL commands to create the database and tables.
# The SQL commands are written to the file "CreateTables.sql" in the current directory.

# create_table_sql() {
#     echo "CREATE TABLE $1 (
#         id INTEGER PRIMARY KEY AUTOINCREMENT,
#         $2
#     );" >> $file
# }

function recreateFile(){
  file="$1"

  if [ -f "$file" ]; then
    rm -f $file
  fi

  touch $file
  echo "Created new script ($file)..."
}

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
  file="$2"

  echo "-- AS ROOT:" >> $file
  echo "-- --------" >> $file
  echo "-- CREATE DATABASE $dbname;" >> $file
  #echo "-- CREATE DATABASE IF NOT EXISTS $dbname;" >> $file
  echo "" >> $file
  echo "-- USE $dbname;" >> $file

  echo "-- GRANT ALL PRIVILEGES ON $dbname.* TO '$3'@'localhost';" >> $file #IDENTIFIED BY '$dbname';" >> $2
  echo "" >> $file
  echo "-- NUCLEAR: GRANT ALL PRIVILEGES ON *.*  TO '$3'@'localhost';" >> $file

  echo "" >> $file
}

function createTableLongtext() {
  dbname="db_"$1
  tableName="tbl_"$1"_longtext"
  file="$2"

  echo "USE $dbname;" >> $file
  echo "" >> $file
  #https://www.mysqltutorial.org/mysql-uuid/
  echo "CREATE TABLE IF NOT EXISTS $tableName (
      id BINARY(16) PRIMARY KEY,
      name LONGTEXT NOT NULL
);" >> $file

  echo "" >> $file
}

function createTableFloat() {
  dbname="db_"$1
  tableName="tbl_"$1
  file="$2"

  echo "USE $dbname;" >> $file
  echo "" >> $file

  echo "CREATE TABLE IF NOT EXISTS $tableName (
      id BINARY(16) PRIMARY KEY,
      value FLOAT(30,6)
);" >> $file

  echo "" >> $file
}


function insertIntoTableFloat() {
  dbname="db_"$1
  tableName="tbl_"$1
  file="$2"
  insertFile="$3"

  if [ ! -f "$insertFile" ]; then
    echo "1"
    return
  fi

  # BAD: (but would likely work)
    #echo "INSERT INTO $tableName (id, name) VALUES (1, 'John');" >> $file
    #https://www.mysqltutorial.org/mysql-uuid/
    # INSERT INTO customers(id, name)
    # VALUES(UUID_TO_BIN(UUID()),'John Doe'),
    #       (UUID_TO_BIN(UUID()),'Will Smith'),
    #       (UUID_TO_BIN(UUID()),'Mary Jane');

  # First go (UNTESTED):
  # echo "LOAD DATA INFILE '$insertFile' INTO TABLE $tableName IGNORE 2 LINES;" #>> $file #Date created, and how many lines...
  
  #Second:
  # echo "USE $dbname; " >> $file
  # echo "" >> $file
  # echo "LOAD DATA INFILE '$insertFile' " >> $file
  # echo "INTO TABLE $tableName " >> $file
  # echo "FIELDS TERMINATED BY ',' " >> $file
  # # echo "ENCLOSED BY '\"' " >> $file #currently they ARE NOT
  # echo "LINES TERMINATED BY '\n' " >> $file
  # echo "IGNORE 2 LINES " >> $file #https://stackoverflow.com/questions/1618355/load-data-local-how-do-i-skip-the-first-line 
  # echo "(@uuid,col2) " >> $file
  # echo "SET col1= UUID_TO_BIN(@uuid);" >> $file

  #Single Line to use command VS. .sql/CAT
  echo "USE $dbname; LOAD DATA INFILE '$insertFile' INTO TABLE $tableName FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 2 LINES (@uuid,value) SET id= UUID_TO_BIN(@uuid);" >> $file

  echo "0"
}

function insertIntoTableLongtext() {
  tableName="tbl_"$1"_longtext"
  file="$2"
  insertFile="$3"

  if [ ! -f "$insertFile" ]; then
    echo "1"
    return
  fi

  # BAD: (but would likely work)
    #echo "INSERT INTO $tableName (id, name) VALUES (1, 'John');" >> $file

    #https://www.mysqltutorial.org/mysql-uuid/
    # INSERT INTO customers(id, name)
    # VALUES(UUID_TO_BIN(UUID()),'John Doe'),
    #       (UUID_TO_BIN(UUID()),'Will Smith'),
    #       (UUID_TO_BIN(UUID()),'Mary Jane');

  # First go (UNTESTED):
  # echo "LOAD DATA INFILE '$insertFile' INTO TABLE $tableName IGNORE 2 LINES;" #>> $file #Date created, and how many lines...

  #Second:  
  # echo "USE $dbname;" >> $file
  # echo "" >> $file
  # echo "LOAD DATA INFILE '$insertFile' " >> $file
  # echo "INTO TABLE $tableName " >> $file
  # echo "FIELDS TERMINATED BY ',' " >> $file
  # # echo "ENCLOSED BY '\"' " >> $file #currently they ARE NOT
  # echo "LINES TERMINATED BY '\n' " >> $file
  # echo "IGNORE 2 LINES " >> $file #https://stackoverflow.com/questions/1618355/load-data-local-how-do-i-skip-the-first-line 
  # echo "(@uuid,col2) " >> $file
  # echo "SET col1= UUID_TO_BIN(@uuid);" >> $file

  #Single Line to use command VS. .sql/CAT
  echo "USE $dbname; LOAD DATA INFILE '$insertFile' INTO TABLE $tableName FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 2 LINES (@uuid,value) SET id= UUID_TO_BIN(@uuid);" >> $file

  echo "0"
}

if [ $# -ne 1 ]; then
  echo "Usage: $0 <action>"
  echo "  action: create | create-longtext | insert | insert-longtext"
  exit 1
fi

user="bigdata"

# commandline argument check if $1 is "build", then build the project
if [ "$1" == "create" ] || [ "$1" == "create-longtext" ]; then
  file="CreateTables.sql"
  # echo "Creating new script ($file)..."

  recreateFile $file

  # createRandFloat 
  createDatabase "test" "$file" "$user"

  mode="Float"
  if [ "$1" == "create" ]; then
    createTableFloat "test" "$file"
  else
    createTableLongtext "test" "$file"
    mode="Longtext"
  fi
  echo "Removed old file (if present), compiled create script with ($mode) settings..."


elif [ "$1" == "insert" ] || [ "$1" == "insert-longtext" ]; then
  file="InsertTables.sql"
  generatedFloatsFile="generateRandFloat.csv"

  recreateFile $file
  
  mode="Float"
  retVal=0
  if [ "$1" == "insert" ]; then
    retVal=`insertIntoTableFloat "test" "$file" "$generatedFloatsFile"`
  else
    retVal=`insertIntoTableLongtext "test" "$file" "$generatedFloatsFile"`
    mode="Longtext"
  fi

  # echo "[DEBUG] Return value: $retVal"

  if [ "$retVal" -eq 0 ]; then
    echo "Removed old file (if present), compiled insert script with ($mode) settings..."
  else
    if [ "$retVal" -eq 1 ]; then
      echo "[ERROR] File '$generatedFloatsFile' does not exist!"
    else 
      echo "Error: Failed to generate insert script..."
    fi
  fi

fi

echo "Done!"
