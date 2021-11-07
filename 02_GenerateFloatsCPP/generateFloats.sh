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
    echo "Generating $2 floats to $outputFile"
    ./"$generatorName" "$2" > "$outputFile"
  fi
  mv "$outputFile" ../
  exit 0
fi

fi

echo "Done!"
