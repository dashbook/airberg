bin/$AIRBYTE_SOURCE --config /tmp/config/source.json --discover | grep "^{\"type\":\"CATALOG\".*}" > discover.json
destination-iceberg --config /tmp/config/destination.json --catalog discover.json > catalog.json
destination-iceberg --config /tmp/config/destination.json --catalog discover.json --state > state.json
bin/$AIRBYTE_SOURCE --config /tmp/config/source.json --catalog catalog.json --read | destination-iceberg --config /tmp/config/destination.json --catalog catalog.json --write
