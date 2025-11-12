#!/bin/bash

cat /tmp/config/source.json | envsubst >/airbyte/source.json
cat /tmp/config/destination.json | envsubst >/airbyte/destination.json

echo "Discovering"
bin/$AIRBYTE_SOURCE --config source.json --discover | grep "^{\"type\":\"CATALOG\".*}" >discover.json

echo "Configuring catalog"
destination-iceberg --config destination.json --catalog discover.json >catalog.json

echo "Getting state"
destination-iceberg --config destination.json --catalog catalog.json --state >state.json

echo "Syncing"
bin/$AIRBYTE_SOURCE --config source.json --catalog catalog.json --state state.json --read | destination-iceberg --config destination.json --catalog catalog.json --write
