# Source postgres

## Example
```json
{
  "host": "localhost",
  "port": 5432,
  "database": "test",
  "schemas": ["public", "my_schema"],
  "username": "airbyte",
  "password": "password123",
  "jdbc_url_params": "key1=value1&key2=value2",
  "ssl_mode": {
    "mode": "verify-ca",
    "ca_certificate": "-----BEGIN CERTIFICATE-----...-----END CERTIFICATE-----",
    "client_certificate": "-----BEGIN CERTIFICATE-----...-----END CERTIFICATE-----",
    "client_key": "-----BEGIN RSA PRIVATE KEY-----...-----END RSA PRIVATE KEY-----",
    "client_key_password": "password123"
  },
  "replication_method": {
    "method": "CDC",
    "plugin": "pgoutput",
    "replication_slot": "replication_slot_name",
    "publication": "publication_name",
    "initial_waiting_seconds": 300,
    "queue_size": 10000,
    "lsn_commit_behaviour": "After loading Data in the destination"
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host |string||null|Hostname of the database.|
|port |integer||5432|Port of the database.|
|database |string||null|Name of the database.|
|schemas |array||["public"]|The list of schemas (case sensitive) to sync from. Defaults to public.|
|username |string||null|Username to access the database.|
|password |string||null|Password associated with the username.|
|jdbc_url_params |string||null|Additional properties to pass to the JDBC URL string when connecting to the database formatted as 'key=value' pairs separated by the symbol '&'. (Eg. key1=value1&key2=value2&key3=value3). For more information read about <a href="https://jdbc.postgresql.org/documentation/head/connect.html">JDBC URL parameters</a>.|
|ssl_mode |||null|Disables encryption of communication between Airbyte and source database.|
|ssl_mode |||null|Enables encryption only when required by the source database.|
|ssl_mode |||null|Allows unencrypted connection only if the source database does not support encryption.|
|ssl_mode |||null|Always require encryption. If the source database server does not support encryption, connection will fail.|
|ssl_mode |||null|Always require encryption and verifies that the source database server has a valid SSL certificate.|
|ssl_mode |||null|This is the most secure mode. Always require encryption and verifies the identity of the source database server.|
|ssl_mode.mode 0|string|disable|null||
|ssl_mode.mode 1|string|allow|null||
|ssl_mode.mode 2|string|prefer|null||
|ssl_mode.mode 3|string|require|null||
|ssl_mode.mode 4|string|verify-ca|null||
|ssl_mode.ca_certificate 4|string||null|CA certificate|
|ssl_mode.client_certificate 4|string||null|Client certificate|
|ssl_mode.client_key 4|string||null|Client key|
|ssl_mode.client_key_password 4|string||null|Password for keystorage. If you do not add it - the password will be generated automatically.|
|ssl_mode.mode 5|string|verify-full|null||
|ssl_mode.ca_certificate 5|string||null|CA certificate|
|ssl_mode.client_certificate 5|string||null|Client certificate|
|ssl_mode.client_key 5|string||null|Client key|
|ssl_mode.client_key_password 5|string||null|Password for keystorage. If you do not add it - the password will be generated automatically.|
|replication_method |||null|Standard replication requires no setup on the DB side but will not be able to represent deletions incrementally.|
|replication_method |||null|Logical replication uses the Postgres write-ahead log (WAL) to detect inserts, updates, and deletes. This needs to be configured on the source database itself. Only available on Postgres 10 and above. Read the <a href="https://docs.airbyte.com/integrations/sources/postgres">docs</a>.|
|replication_method.method 0|string|Standard|null||
|replication_method.method 1|string|CDC|null||
|replication_method.plugin 1|string||pgoutput|A logical decoding plugin installed on the PostgreSQL server.|
|replication_method.replication_slot 1|string||null|A plugin logical replication slot. Read about <a href="https://docs.airbyte.com/integrations/sources/postgres#step-3-create-replication-slot">replication slots</a>.|
|replication_method.publication 1|string||null|A Postgres publication used for consuming changes. Read about <a href="https://docs.airbyte.com/integrations/sources/postgres#step-4-create-publications-and-replication-identities-for-tables">publications and replication identities</a>.|
|replication_method.initial_waiting_seconds 1|integer||300|The amount of time the connector will wait when it launches to determine if there is new data to sync or not. Defaults to 300 seconds. Valid range: 120 seconds to 1200 seconds. Read about <a href="https://docs.airbyte.com/integrations/sources/postgres#step-5-optional-set-up-initial-waiting-time">initial waiting time</a>.|
|replication_method.queue_size 1|integer||10000|The size of the internal queue. This may interfere with memory consumption and efficiency of the connector, please be careful.|
|replication_method.lsn_commit_behaviour 1|string||After loading Data in the destination|Determines when Airbtye should flush the LSN of processed WAL logs in the source database. `After loading Data in the destination` is default. If `While reading Data` is selected, in case of a downstream failure (while loading data into the destination), next sync would result in a full sync.|

# Postgres Source

## Performance Test

To run performance tests in commandline:
```shell
./gradlew :airbyte-integrations:connectors:source-postgres:performanceTest [--cpulimit=cpulimit/<limit>] [--memorylimit=memorylimit/<limit>]
```

In pull request:
```shell
/test-performance connector=connectors/source-postgres [--cpulimit=cpulimit/<limit>] [--memorylimit=memorylimit/<limit>]
```

- `cpulimit`: Limit the number of CPUs. The minimum is `2`. E.g. `--cpulimit=cpulimit/2`.
- `memorylimit`: Limit the size of the memory. Must include the unit at the end (e.g. `MB`, `GB`). The minimum size is `6MB`. E.g. `--memorylimit=memorylimit/4GB`.
- When none of the CPU or memory limit is provided, the performance tests will run without memory or CPU limitations. The available resource will be bound that those specified in `ResourceRequirements.java`.

### Use Postgres script to populate the benchmark database

In order to create a database with a certain number of tables, and a certain number of records in each of them, 
you need to follow a few simple steps.

1. Create a new database.
2. Follow the TODOs in [3-run-script.sql](src/test-performance/sql/3-run-script.sql) to change the number of tables, and the number of records of different sizes.
3. On the new database, run the following script:
   ```shell
   cd airbyte-integrations/connectors/source-postgres
   psql -h <host> -d <db-name> -U <username> -p <port> -a -q -f src/test-performance/sql/1-create-copy-tables-procedure.sql
   psql -h <host> -d <db-name> -U <username> -p <port> -a -q -f src/test-performance/sql/2-create-insert-rows-to-table-procedure.sql
   psql -h <host> -d <db-name> -U <username> -p <port> -a -q -f src/test-performance/sql/3-run-script.sql
   ```
4. After the script finishes, you will receive the number of tables specified in the script, with names starting with **test_0** and ending with **test_(the number of tables minus 1)**.
