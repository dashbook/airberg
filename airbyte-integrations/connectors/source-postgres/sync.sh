bin/source-postgres --config config/source.json --discover | grep "^{\"type\":\"CATALOG\".*}" > discover.json
destination-iceberg --config config/destination.json --catalog discover.json > catalog.json
destination-iceberg --config config/destination.json --catalog discover.json --state > state.json
bin/source-postgres --config config/source.json --catalog catalog.json --read | destination-iceberg --config config/destination.json --catalog catalog.json --write
