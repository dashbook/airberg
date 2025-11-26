#!/bin/bash

cat /tmp/config/source.json | envsubst > /airbyte/source.json 
cat /tmp/config/destination.json | envsubst > /airbyte/destination.json

echo "Discovering"
python main.py discover --config source.json | grep "^{\"type\": \"CATALOG\".*}" > discover.json

echo "Configuring catalog"
destination-iceberg --config destination.json --catalog discover.json > catalog.json

echo "Getting state"
destination-iceberg --config destination.json --catalog catalog.json --state > state.json

echo "Syncing"
python main.py read --config source.json --catalog catalog.json --state state.json | destination-iceberg --config destination.json --catalog catalog.json --write
