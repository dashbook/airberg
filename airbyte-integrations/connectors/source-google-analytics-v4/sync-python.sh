#!/bin/bash

echo "Discovering"
python main.py --config /tmp/config/source.json --discover | grep "^{\"type\":\"CATALOG\".*}" > discover.json

echo "Configuring catalog"
destination-iceberg --config /tmp/config/destination.json --catalog discover.json > catalog.json

echo "Getting state"
destination-iceberg --config /tmp/config/destination.json --catalog discover.json --state > state.json

echo "Syncing"
python main.py --config /tmp/config/source.json --catalog catalog.json --state state.json --read | destination-iceberg --config /tmp/config/destination.json --catalog catalog.json --write
