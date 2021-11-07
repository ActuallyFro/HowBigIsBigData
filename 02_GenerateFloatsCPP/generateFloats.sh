#!/bin/bash
generatorName="generateRandFloat"
generatorSource="${generatorName}.cpp"
outputFile="${generatorName}.md"

# commandline argument check if $1 is "build", then build the project
if [ "$1" == "build" ]; then
  echo "Building project..."
  g++ -o "$generatorName" "$generatorSource" -std=c++17
  echo "Done!"
  exit 0

#if "--help"
elif [ "$1" == "--help" ] || [ "$1" == "" ]; then
  echo "Usage: $0 [OPTION]"
  echo "Options:"
  echo "  --help: Print this help message"
  echo "  build: Build the project"
  exit 0
fi

echo "Generating random floats..."
./generateRandFloat > "$outputFile"
echo "Done!"
