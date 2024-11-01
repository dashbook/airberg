# Source mssql

## Example
```
{
  "host": "localhost",
  "port": 1433,
  "database": "master",
  "schemas": [
    "dbo"
  ],
  "username": "myuser",
  "password": "mypassword",
  "jdbc_url_params": "",
  "ssl_method": {
    "ssl_method": "encrypted_verify_certificate",
    "hostNameInCertificate": "localhost"
  },
  "replication_method": {
    "method": "CDC",
    "data_to_sync": "Existing and New",
    "snapshot_isolation": "Snapshot",
    "initial_waiting_seconds": 300
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host|string||null|The hostname of the database.|
|port|integer||null|The port of the database.|
|database|string||null|The name of the database.|
|schemas|array||["dbo"]|The list of schemas to sync from. Defaults to user. Case sensitive.|
|username|string||null|The username which is used to access the database.|
|password|string||null|The password associated with the username.|
|jdbc_url_params|string||null|Additional properties to pass to the JDBC URL string when connecting to the database formatted as 'key=value' pairs separated by the symbol '&'. (example: key1=value1&key2=value2&key3=value3).|
|ssl_method|object||null|The encryption method which is used when communicating with the database.|
|replication_method|object||STANDARD|The replication method used for extracting data from the database. STANDARD replication requires no setup on the DB side but will not be able to represent deletions incrementally. CDC uses {TBC} to detect inserts, updates, and deletes. This needs to be configured on the source database itself.|
|ssl_method.0.ssl_method|string|unencrypted|null||
|ssl_method.1.ssl_method|string|encrypted_trust_server_certificate|null||
|ssl_method.2.ssl_method|string|encrypted_verify_certificate|null||
|ssl_method.2.hostNameInCertificate|string||null|Specifies the host name of the server. The value of this property must match the subject property of the certificate.|
|replication_method.0.method|string|STANDARD|null||
|replication_method.1.method|string|CDC|null||
|replication_method.1.data_to_sync|string||Existing and New|What data should be synced under the CDC. "Existing and New" will read existing data as a snapshot, and sync new changes through CDC. "New Changes Only" will skip the initial snapshot, and only sync new changes through CDC.|
|replication_method.1.snapshot_isolation|string||Snapshot|Existing data in the database are synced through an initial snapshot. This parameter controls the isolation level that will be used during the initial snapshotting. If you choose the "Snapshot" level, you must enable the <a href="https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/sql/snapshot-isolation-in-sql-server">snapshot isolation mode</a> on the database.|
|replication_method.1.initial_waiting_seconds|integer||300|The amount of time the connector will wait when it launches to determine if there is new data to sync or not. Defaults to 300 seconds. Valid range: 120 seconds to 1200 seconds. Read about <a href="https://docs.airbyte.com/integrations/sources/mysql/#change-data-capture-cdc">initial waiting time</a>.|

# MsSQL (SQL Server) Source

## Performance Test

To run performance tests in commandline:
```shell
./gradlew :airbyte-integrations:connectors:source-mssql:performanceTest [--cpulimit=cpulimit/<limit>] [--memorylimit=memorylimit/<limit>]
```

In pull request:
```shell
/test-performance connector=connectors/source-mssql [--cpulimit=cpulimit/<limit>] [--memorylimit=memorylimit/<limit>]
```

- `cpulimit`: Limit the number of CPUs. The minimum is `2`. E.g. `--cpulimit=cpulimit/2`.
- `memorylimit`: Limit the size of the memory. Must include the unit at the end (e.g. `MB`, `GB`). The minimum size is `6MB`. E.g. `--memorylimit=memorylimit/4GB`.
- When none of the CPU or memory limit is provided, the performance tests will run without memory or CPU limitations. The available resource will be bound that those specified in `ResourceRequirements.java`.

### Use MsSQL script to populate the benchmark database

In order to create a database with a certain number of tables, and a certain number of records in each of them, 
you need to follow a few simple steps.

1. Create a new database.
2. Follow the TODOs in [create_mssql_benchmarks.sql](src/test-performance/sql/create_mssql_benchmarks.sql) to change the number of tables, and the number of records of different sizes.
3. Execute the script with your changes for the new database. You can run the script with the MySQL client:
   ```bash
   cd airbyte-integrations/connectors/source-mssql
   sqlcmd -S Serverinstance -E -i src/test-performance/sql/create_mssql_benchmarks.sql
   ```
4. After the script finishes its work, you will receive the number of tables specified in the script, with names starting with **test_0** and ending with **test_(the number of tables minus 1)**.
