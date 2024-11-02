# Source mysql

## Example
```
{
  "host": "localhost",
  "port": 3306,
  "database": "my_database",
  "username": "my_username",
  "password": "my_password",
  "jdbc_url_params": "",
  "ssl": true,
  "ssl_mode": {
    "mode": "verify_ca",
    "ca_certificate": "-----BEGIN CERTIFICATE-----...",
    "client_certificate": "-----BEGIN CERTIFICATE-----...",
    "client_key": "-----BEGIN RSA PRIVATE KEY-----...",
    "client_key_password": "my_client_key_password"
  },
  "replication_method": {
    "method": "CDC",
    "initial_waiting_seconds": 300,
    "server_time_zone": "America/New_York"
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host |string||null|The host name of the database.|
|port |integer||3306|The port to connect to.|
|database |string||null|The database name.|
|username |string||null|The username which is used to access the database.|
|password |string||null|The password associated with the username.|
|jdbc_url_params |string||null|Additional properties to pass to the JDBC URL string when connecting to the database formatted as 'key=value' pairs separated by the symbol '&'. (example: key1=value1&key2=value2&key3=value3). For more information read about <a href="https://dev.mysql.com/doc/connector-j/8.0/en/connector-j-reference-jdbc-url-format.html">JDBC URL parameters</a>.|
|ssl |boolean||true|Encrypt data using SSL.|
|ssl_mode |||null|Automatically attempt SSL connection. If the MySQL server does not support SSL, continue with a regular connection.|
|ssl_mode |||null|Always connect with SSL. If the MySQL server doesn’t support SSL, the connection will not be established. Certificate Authority (CA) and Hostname are not verified.|
|ssl_mode |||null|Always connect with SSL. Verifies CA, but allows connection even if Hostname does not match.|
|ssl_mode |||null|Always connect with SSL. Verify both CA and Hostname.|
|ssl_mode.mode 0|string|preferred|null||
|ssl_mode.mode 1|string|required|null||
|ssl_mode.mode 2|string|verify_ca|null||
|ssl_mode.ca_certificate 2|string||null|CA certificate|
|ssl_mode.client_certificate 2|string||null|Client certificate (this is not a required field, but if you want to use it, you will need to add the <b>Client key</b> as well)|
|ssl_mode.client_key 2|string||null|Client key (this is not a required field, but if you want to use it, you will need to add the <b>Client certificate</b> as well)|
|ssl_mode.client_key_password 2|string||null|Password for keystorage. This field is optional. If you do not add it - the password will be generated automatically.|
|ssl_mode.mode 3|string|verify_identity|null||
|ssl_mode.ca_certificate 3|string||null|CA certificate|
|ssl_mode.client_certificate 3|string||null|Client certificate (this is not a required field, but if you want to use it, you will need to add the <b>Client key</b> as well)|
|ssl_mode.client_key 3|string||null|Client key (this is not a required field, but if you want to use it, you will need to add the <b>Client certificate</b> as well)|
|ssl_mode.client_key_password 3|string||null|Password for keystorage. This field is optional. If you do not add it - the password will be generated automatically.|
|replication_method |||null|Standard replication requires no setup on the DB side but will not be able to represent deletions incrementally.|
|replication_method |||null|CDC uses the Binlog to detect inserts, updates, and deletes. This needs to be configured on the source database itself.|
|replication_method.method 0|string|STANDARD|null||
|replication_method.method 1|string|CDC|null||
|replication_method.initial_waiting_seconds 1|integer||300|The amount of time the connector will wait when it launches to determine if there is new data to sync or not. Defaults to 300 seconds. Valid range: 120 seconds to 1200 seconds. Read about <a href="https://docs.airbyte.com/integrations/sources/mysql/#change-data-capture-cdc">initial waiting time</a>.|
|replication_method.server_time_zone 1|string||null|Enter the configured MySQL server timezone. This should only be done if the configured timezone in your MySQL instance does not conform to IANNA standard.|

# MySQL Source

## Documentation
This is the repository for the MySQL only source connector in Java.
For information about how to use this connector within Airbyte, see [User Documentation](https://docs.airbyte.io/integrations/sources/mysql)

## Local development

#### Building via Gradle
From the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-mysql:build
```

### Locally running the connector docker image

#### Build
Build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-mysql:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

## Testing
We use `JUnit` for Java tests.

### Acceptance Tests
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-mysql:integrationTest
```

### Performance Tests

To run performance tests in commandline:
```shell
./gradlew :airbyte-integrations:connectors:source-mysql:performanceTest [--cpulimit=cpulimit/<limit>] [--memorylimit=memorylimit/<limit>]
```

In pull request:
```shell
/test-performance connector=connectors/source-mysql [--cpulimit=cpulimit/<limit>] [--memorylimit=memorylimit/<limit>]
```

- `cpulimit`: Limit the number of CPUs. The minimum is `2`. E.g. `--cpulimit=cpulimit/2`.
- `memorylimit`: Limit the size of the memory. Must include the unit at the end (e.g. `MB`, `GB`). The minimum size is `6MB`. E.g. `--memorylimit=memorylimit/4GB`.
- When none of the CPU or memory limit is provided, the performance tests will run without memory or CPU limitations. The available resource will be bound that those specified in `ResourceRequirements.java`.

#### Use MySQL script to populate the benchmark database

In order to create a database with a certain number of tables, and a certain number of records in each of them,
you need to follow a few simple steps.

1. Create a new database.
2. Follow the TODOs in [create_mysql_benchmarks.sql](src/test-performance/sql/create_mysql_benchmarks.sql) to change the number of tables, and the number of records of different sizes.
3. Execute the script with your changes for the new database. You can run the script using the MySQL command line client:
   ```shell
   cd airbyte-integrations/connectors/source-mysql
   mysql -h hostname -u user database < src/test-performance/sql/create_mysql_benchmarks.sql
   ```   
4. After the script finishes its work, you will receive the number of tables specified in the script, with names starting with **test_0** and ending with **test_(the number of tables minus 1)**.
