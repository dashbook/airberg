# Source postgres

## Example
```
{
  "host": "localhost",
  "port": 5432,
  "database": "mydatabase",
  "schemas": ["public", "myschema"],
  "username": "myuser",
  "password": "mypassword",
  "jdbc_url_params": "key1=value1&key2=value2",
  "ssl_mode": {
    "mode": "require",
    "ca_certificate": "path/to/ca/certificate",
    "client_certificate": "path/to/client/certificate",
    "client_key": "path/to/client/key",
    "client_key_password": "mypassword"
  },
  "replication_method": {
    "method": "CDC",
    "plugin": "pgoutput",
    "replication_slot": "myslot",
    "publication": "mypublication",
    "initial_waiting_seconds": 300,
    "queue_size": 10000,
    "lsn_commit_behaviour": "After loading Data in the destination"
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host|string||null|Hostname of the database.|
|port|integer||5432|Port of the database.|
|database|string||null|Name of the database.|
|schemas|array||["public"]|The list of schemas (case sensitive) to sync from. Defaults to public.|
|username|string||null|Username to access the database.|
|password|string||null|Password associated with the username.|
|jdbc_url_params|string||null|Additional properties to pass to the JDBC URL string when connecting to the database formatted as 'key=value' pairs separated by the symbol '&'. (Eg. key1=value1&key2=value2&key3=value3). For more information read about <a href="https://jdbc.postgresql.org/documentation/head/connect.html">JDBC URL parameters</a>.|
|ssl_mode|object||null|SSL connection modes. 
  Read more <a href="https://jdbc.postgresql.org/documentation/head/ssl-client.html"> in the docs</a>.|
|replication_method|object||null|Replication method for extracting data from the database.|
|ssl_mode.0.mode|string|disable|null||
|ssl_mode.1.mode|string|allow|null||
|ssl_mode.2.mode|string|prefer|null||
|ssl_mode.3.mode|string|require|null||
|ssl_mode.4.mode|string|verify-ca|null||
|ssl_mode.4.ca_certificate|string||null|CA certificate|
|ssl_mode.4.client_certificate|string||null|Client certificate|
|ssl_mode.4.client_key|string||null|Client key|
|ssl_mode.4.client_key_password|string||null|Password for keystorage. If you do not add it - the password will be generated automatically.|
|ssl_mode.5.mode|string|verify-full|null||
|ssl_mode.5.ca_certificate|string||null|CA certificate|
|ssl_mode.5.client_certificate|string||null|Client certificate|
|ssl_mode.5.client_key|string||null|Client key|
|ssl_mode.5.client_key_password|string||null|Password for keystorage. If you do not add it - the password will be generated automatically.|
|replication_method.0.method|string|Standard|null||
|replication_method.1.method|string|CDC|null||
|replication_method.1.plugin|string||pgoutput|A logical decoding plugin installed on the PostgreSQL server.|
|replication_method.1.replication_slot|string||null|A plugin logical replication slot. Read about <a href="https://docs.airbyte.com/integrations/sources/postgres#step-3-create-replication-slot">replication slots</a>.|
|replication_method.1.publication|string||null|A Postgres publication used for consuming changes. Read about <a href="https://docs.airbyte.com/integrations/sources/postgres#step-4-create-publications-and-replication-identities-for-tables">publications and replication identities</a>.|
|replication_method.1.initial_waiting_seconds|integer||300|The amount of time the connector will wait when it launches to determine if there is new data to sync or not. Defaults to 300 seconds. Valid range: 120 seconds to 1200 seconds. Read about <a href="https://docs.airbyte.com/integrations/sources/postgres#step-5-optional-set-up-initial-waiting-time">initial waiting time</a>.|
|replication_method.1.queue_size|integer||10000|The size of the internal queue. This may interfere with memory consumption and efficiency of the connector, please be careful.|
|replication_method.1.lsn_commit_behaviour|string||After loading Data in the destination|Determines when Airbtye should flush the LSN of processed WAL logs in the source database. `After loading Data in the destination` is default. If `While reading Data` is selected, in case of a downstream failure (while loading data into the destination), next sync would result in a full sync.|

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
