# Airberg

Simple docker containers to load Airbyte Sources into Apache Iceberg tables.

## Usage

With the following command you run a docker container to fetch the latest data and insert it into the according Icebert tables:

```bash
docker run --rm -it -v .:/tmp/config -e POSTGRES_PASSWORD=postgres dashbook/source-postgres:sql
```

## Configuration

The configuration is done with a `source.json` and a `destination.json` file. These files have to be mounted in the docker container under the `/tmp/config` path.

### Source config

The `source.json` file contains the configuration parameters for the Airbyte source. The parameters for a specific source can be takes from the [list of sources](sources.md).
An example looks like the following:

```json
{
    "host": "postgres",
    "port": 5432,
    "username": "postgres",
    "password": "$POSTGRES_PASSWORD",
    "database": "postgres",
    "schemas": ["inventory"],
    "ssl_mode": { "mode": "disable" },
    "replication_method": {
      "method": "CDC",
      "replication_slot": "airbyte_slot",
      "publication": "airbyte_publication"
    }
  }
```

### Destination config

The `destination.json` file contains the configuration parameters for the Airbyte [Iceberg destination](https://github.com/dashbook/destination-iceberg). An example configuration looks like the following:

```json
{
    "catalogName": "bronze",
    "catalogUrl": "postgres://postgres:$POSTGRES_PASSWORD@postgres:5432",
    "awsRegion": "us-east-1",
    "awsAccessKeyId": "$AWS_ACCESS_KEY_ID",
    "awsSecretAccessKey": "$AWS_SECRET_ACCESS_KEY",
    "awsEndpoint": "http://localstack:4566",
    "awsAllowHttp": "true",
    "bucket": "s3://example-kafka"
  }
```

## Environment variables

Environment variables are automatically substituted in the configuration files. They are the best way to use secrets for the configuration.
