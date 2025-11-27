# Airberg

Simple Docker containers to load data from [Airbyte Sources](https://airbyte.com/connectors) into [Apache Iceberg](https://iceberg.apache.org/) tables.

Airberg combines the extensive connector ecosystem of Airbyte with the powerful table format of Apache Iceberg, making it easy to build modern data lakehouse architectures.

## Features

- **70+ Data Sources** - Connect to databases, SaaS applications, APIs, and more
- **Iceberg Native** - Direct writes to Iceberg tables with ACID guarantees
- **Change Data Capture** - Real-time CDC support for databases
- **Incremental Sync** - Efficient updates with automatic state management
- **Docker-based** - Simple deployment without complex orchestration
- **Multiple Storage Backends** - Support for both file-based and SQL catalog storage

## Quick Start

Run a Docker container to fetch data from your source and load it into Iceberg tables:

```bash
docker run --rm -it \
  -v .:/tmp/config \
  -e POSTGRES_PASSWORD=postgres \
  dashbook/source-postgres:sql
```

This command will:
1. Read configuration from `source.json` and `destination.json` in the current directory
2. Connect to your PostgreSQL database
3. Discover the schema and fetch data
4. Write data to Iceberg tables in your configured catalog

## Configuration

Airberg uses two configuration files that must be mounted in the Docker container at `/tmp/config`:
- `source.json` - Source connector configuration
- `destination.json` - Iceberg destination configuration

### Source Configuration

The `source.json` file contains connection parameters for your data source. Configuration options vary by connector - see the [list of available sources](sources.md) for specific parameters.

**Example: PostgreSQL with CDC**

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

### Destination Configuration

The `destination.json` file configures the Iceberg destination, including catalog settings and storage location.

This example uses the [Iceberg destination](https://github.com/dashbook/destination-iceberg) with a PostgreSQL catalog and S3-compatible storage:

**Example: Iceberg with PostgreSQL Catalog and S3**

```json
{
    "catalog_name": "bronze",
    "catalog_url": "postgres://postgres:$POSTGRES_PASSWORD@postgres:5432",
    "aws_region": "us-east-1",
    "aws_access_key_id": "$AWS_ACCESS_KEY_ID",
    "aws_secret_access_key": "$AWS_SECRET_ACCESS_KEY",
    "aws_endpoint": "http://localstack:4566",
    "aws_allow_http": "true",
    "bucket": "s3://example-kafka"
  }
```

## Environment Variables

Environment variables in configuration files are automatically substituted at runtime using the `$VARIABLE_NAME` syntax. This is the recommended approach for managing sensitive credentials.

**Example:**
```json
{
  "password": "$POSTGRES_PASSWORD",
  "aws_access_key_id": "$AWS_ACCESS_KEY_ID"
}
```

Pass environment variables when running the container:
```bash
docker run --rm -it \
  -v .:/tmp/config \
  -e POSTGRES_PASSWORD=secret123 \
  -e AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE \
  dashbook/source-postgres:sql
```

## Available Sources

Airberg supports 70+ connectors including:

**Databases**
- PostgreSQL, MySQL, MongoDB, SQL Server, Oracle
- [See all database sources →](sources.md)

**SaaS Applications**
- Salesforce, HubSpot, Google Analytics, Facebook Marketing
- Microsoft Dynamics 365 / Dataverse
- [See all SaaS sources →](sources.md)

**File Sources**
- S3, Google Cloud Storage, Azure Blob Storage
- Local files (CSV, JSON, Parquet)

For the complete list of supported sources and their configuration options, see the [sources documentation](sources.md).

## Storage Variants

Each connector is available in two variants:

### SQL Catalog (`:sql` tag)
Uses a SQL database (PostgreSQL, MySQL, etc.) as the Iceberg catalog. Recommended for production deployments.

```bash
docker run --rm -it -v .:/tmp/config dashbook/source-postgres:sql
```

### File Catalog (`:file` tag)
Uses file-based Iceberg catalog. Simpler setup, suitable for development and small-scale deployments.

```bash
docker run --rm -it -v .:/tmp/config dashbook/source-postgres:file
```

## Use Cases

- **Data Lakehouse** - Build a modern lakehouse with ACID transactions
- **Real-time Analytics** - CDC-enabled pipelines for near real-time data
- **Data Integration** - Consolidate data from multiple sources into Iceberg
- **Data Migration** - Move data from legacy systems to Iceberg format
- **ETL/ELT Pipelines** - Simple, containerized data pipelines

## Development

For debugging and development information, see the [Development Guide](DEVELOPMENT.md).

## Contributing

Contributions are welcome! This project builds on:
- [Airbyte](https://github.com/airbytehq/airbyte) - Source connectors
- [Apache Iceberg](https://github.com/apache/iceberg) - Table format
- [destination-iceberg](https://github.com/dashbook/destination-iceberg) - Iceberg destination

## License

MIT
