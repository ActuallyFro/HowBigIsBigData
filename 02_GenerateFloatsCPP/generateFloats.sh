#!/bin/bash
generatorName="generateRandFloat"
generatorSource="${generatorName}.cpp"
outputFile="${generatorName}.csv"

#if "--help"
if [ "$1" == "--help" ] || [ "$1" == "" ]; then
  echo "Usage: $0 [OPTION]"
  echo "Options:"
  echo "  --help: Print this help message"
  echo "  build: Build the project"
  echo "  generate <#>: generates floats (default to 1 if # blank)"
  exit 0
fi

# commandline argument check if $1 is "build", then build the project
if [ "$1" == "build" ]; then
  whereIsGPP=`which g++`

  if [ -z "${whereIsGPP}" ]; then
    echo "[ERROR] g++ not found! -- aborting build!"
    exit 1
  fi

  if [ ! -f "$generatorSource" ]; then
    echo "[ERROR] $generatorSource does not exist! -- aborting build!"
    exit 1
  fi

  echo "Building project..."  

  g++ -o "$generatorName" "$generatorSource" -std=c++17
  echo "Done!"
  exit 0

elif [ "$1" == "generate" ]; then
  if [ "$2" == "" ]; then
    echo "Generating 100 floats to $outputFile"
    ./"$generatorName" > "$outputFile"
  else
    echo "Generating $2 floats to ../$outputFile"
    ./"$generatorName" "$2" > "$outputFile"
  fi
  sed '/^$/d' -i "$outputFile" #delete empty lines
  mv "$outputFile" ../

  echo "[TEST] Checking for Uniqueness..."

  #bash run a local script (CountUniqUUIDs.sh) save result in variable (count)
  count=$(bash ./CountUniqUUIDs.sh)

  # Test if $count == $2
  if [ "$count" == "$2" ]; then
    echo "[TEST] All $count floats are unique!"
  else
    echo "[TEST] $count floats are NOT unique! (expected: $2)"
    diffCount=$(($2 - $count))
    echo "[WARN]     Removing '$diffCount' total duplicates..."

    head -n 1 "../"$outputFile > "./"$outputFile
    echo "-- Tried provided int of '$2', but duplicates reduced it to '$count'!" >> "./"$outputFile

    tail -n +3 "../"$outputFile > NoHeader.csv

    echo "[WARN]     Reducing dupes, and shuffling..."
    cat "../"$outputFile | grep -v "\-\-" | tr "," "\n" | grep -v "\." | sort | uniq -c | sort -n >> UUIDsByCount.md #FULL
    #removed uniques
    cat UUIDsByCount.md | grep -v '^      1 ' | sed "s/      //g" > UUIDdupes.md
    rm UUIDsByCount.md

    arrayOfDupes=($(cat UUIDdupes.md | awk '{print $2}'))
    rm UUIDdupes.md

    #loop over  arrayOfDupes, use sed to remove lines containing the Dupe from NoHeader.csv
    echo "[WARN]     Removing ALL duplicate lines..."
    for i in "${arrayOfDupes[@]}"; do
      sed -i "/$i/d" NoHeader.csv
    done

    echo "[WARN]     Shuffling..."
    cat NoHeader.csv | shuf >> "./"$outputFile

    echo "[WARN]     Moving file back.."
    mv "./"$outputFile ../
    mv temp.csv "../"$outputFile

    echo "[TEST] RE-Checking for Uniqueness..."
    #bash run a local script (CountUniqUUIDs.sh) save result in variable (count)
    countAgain=$(bash ./CountUniqUUIDs.sh)
    deltaCount=$(($2 - $diffCount))
    if [ "$countAgain" == "$deltaCount" ]; then
      echo "[TEST] All $count floats are unique!"
    else
      #ERROR and quit!
      echo "[ERROR] NOT 1:1 UNIQUE! ONLY $countAgain floats are unique! (expected: $deltaCount)"
      exit 2
    fi

  exit 0
fi

fi

echo "Done!"
