#!/bin/bash

echo "Discovering"
bin/$AIRBYTE_SOURCE --config /tmp/config/source.json --discover | grep "^{\"type\":\"CATALOG\".*}" > discover.json

echo "Configuring catalog"
destination-iceberg --config /tmp/config/destination.json --catalog discover.json > catalog.json

echo "Getting state"
destination-iceberg --config /tmp/config/destination.json --catalog discover.json --state > state.json

echo "Syncing"
bin/$AIRBYTE_SOURCE --config /tmp/config/source.json --catalog catalog.json --read | destination-iceberg --config /tmp/config/destination.json --catalog catalog.json --write
