#!/bin/bash

cat /tmp/config/source.json | envsubst > /tmp/config/temp.json && mv /tmp/config/temp.json /tmp/config/source.json
cat /tmp/config/destination.json | envsubst > /tmp/config/temp.json && mv /tmp/config/temp.json /tmp/config/destination.json

echo "Discovering"
python main.py discover --config /tmp/config/source.json | grep "^{\"type\": \"CATALOG\".*}" > discover.json

echo "Configuring catalog"
destination-iceberg --config /tmp/config/destination.json --catalog discover.json > catalog.json

echo "Getting state"
destination-iceberg --config /tmp/config/destination.json --catalog discover.json --state > state.json

echo "Syncing"
python main.py read --config /tmp/config/source.json --catalog catalog.json --state state.json | destination-iceberg --config /tmp/config/destination.json --catalog catalog.json --write
