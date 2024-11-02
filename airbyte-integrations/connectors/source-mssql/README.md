# Source mssql

## Example
```json
{
  "host": "localhost",
  "port": 1433,
  "database": "master",
  "schemas": ["dbo"],
  "username": "username",
  "password": "password",
  "jdbc_url_params": "key1=value1&key2=value2",
  "ssl_method": {
    "ssl_method": "unencrypted"
  },
  "replication_method": {
    "method": "STANDARD"
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host |string||null|The hostname of the database.|
|port |integer||null|The port of the database.|
|database |string||null|The name of the database.|
|schemas |array||["dbo"]|The list of schemas to sync from. Defaults to user. Case sensitive.|
|username |string||null|The username which is used to access the database.|
|password |string||null|The password associated with the username.|
|jdbc_url_params |string||null|Additional properties to pass to the JDBC URL string when connecting to the database formatted as 'key=value' pairs separated by the symbol '&'. (example: key1=value1&key2=value2&key3=value3).|
|ssl_method |||null|Data transfer will not be encrypted.|
|ssl_method |||null|Use the certificate provided by the server without verification. (For testing purposes only!)|
|ssl_method |||null|Verify and use the certificate provided by the server.|
|ssl_method.ssl_method 0|string|unencrypted|null||
|ssl_method.ssl_method 1|string|encrypted_trust_server_certificate|null||
|ssl_method.ssl_method 2|string|encrypted_verify_certificate|null||
|ssl_method.hostNameInCertificate 2|string||null|Specifies the host name of the server. The value of this property must match the subject property of the certificate.|
|replication_method |||null|Standard replication requires no setup on the DB side but will not be able to represent deletions incrementally.|
|replication_method |||null|CDC uses {TBC} to detect inserts, updates, and deletes. This needs to be configured on the source database itself.|
|replication_method.method 0|string|STANDARD|null||
|replication_method.method 1|string|CDC|null||
|replication_method.data_to_sync 1|string||Existing and New|What data should be synced under the CDC. "Existing and New" will read existing data as a snapshot, and sync new changes through CDC. "New Changes Only" will skip the initial snapshot, and only sync new changes through CDC.|
|replication_method.snapshot_isolation 1|string||Snapshot|Existing data in the database are synced through an initial snapshot. This parameter controls the isolation level that will be used during the initial snapshotting. If you choose the "Snapshot" level, you must enable the <a href="https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/sql/snapshot-isolation-in-sql-server">snapshot isolation mode</a> on the database.|
|replication_method.initial_waiting_seconds 1|integer||300|The amount of time the connector will wait when it launches to determine if there is new data to sync or not. Defaults to 300 seconds. Valid range: 120 seconds to 1200 seconds. Read about <a href="https://docs.airbyte.com/integrations/sources/mysql/#change-data-capture-cdc">initial waiting time</a>.|

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
