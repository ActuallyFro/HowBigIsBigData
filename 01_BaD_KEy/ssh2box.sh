#!/bin/bash

localhostStub="192.168.1"
username="focal"

if [ -z "$1" ]; then
  echo "Usage: $0 <localhost addr>"
  exit 1
fi


rootFolder="$(dirname "$(readlink -f "$0")")"

localhostAddr=$localhostStub"."$1

# ssh to localhostAddr with new key
ssh -i $rootFolder/bigdatakey -o StrictHostKeyChecking=no $username"@"$localhostAddr
