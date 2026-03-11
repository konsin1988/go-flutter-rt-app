#!/bin/bash                                                                                                                                                   
#
IP_ADDRESS="$1"

if [ -z "$IP_ADDRESS" ]; then
  echo "Usage: ./run.sh <IP_ADDRESS>"
  exit 1
fi

echo "🚀 Flutter: http://$IP_ADDRESS:8000/graphql | ws://$IP_ADDRESS:8000/graphql"
flutter run \
  --dart-define="BASE_URL=http://$IP_ADDRESS:8000" \
  --dart-define="BASE_WS_URL=ws://$IP_ADDRESS:8000/graphql" \
  -d 0xSZB888DABOBO 
