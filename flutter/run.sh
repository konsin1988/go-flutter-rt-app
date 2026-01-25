#!/bin/bash                                                                                                                                                   
#
IP_ADDRESS="$1"

if [ -z "$IP_ADDRESS" ]; then
  echo "Usage: ./run.sh <IP_ADDRESS>"
  exit 1
fi

flutter run \
  --dart-define=BASE_URL=http://$IP_ADDRESS:8000 \
  -d 0xSZB888DABOBO 
