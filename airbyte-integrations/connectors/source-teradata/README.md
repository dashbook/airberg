# Source teradata

## Example
```json
{
  "host": "example-host",
  "port": 3306,
  "database": "example-database",
  "username": "example-username",
  "password": "example-password",
  "jdbc_url_params": "key1=value1&key2=value2&key3=value3",
  "replication_method": "STANDARD",
  "ssl": true,
  "ssl_mode": {
    "mode": "verify-ca",
    "ssl_ca_certificate": "example-ca-certificate"
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host |string||null|Hostname of the database.|
|port |integer||3306|Port of the database.|
|database |string||null|Name of the database.|
|username |string||null|Username to use to access the database.|
|password |string||null|Password associated with the username.|
|jdbc_url_params |string||null|Additional properties to pass to the JDBC URL string when connecting to the database formatted as 'key=value' pairs separated by the symbol '&'. (example: key1=value1&key2=value2&key3=value3)|
|replication_method |string||STANDARD|Replication method to use for extracting data from the database. STANDARD replication requires no setup on the DB side but will not be able to represent deletions incrementally. CDC uses the Binlog to detect inserts, updates, and deletes. This needs to be configured on the source database itself.|
|ssl |boolean||false|Encrypt data using SSL. When activating SSL, please select one of the connection modes.|
|ssl_mode |||null|Disable SSL.|
|ssl_mode |||null|Allow SSL mode.|
|ssl_mode |||null|Prefer SSL mode.|
|ssl_mode |||null|Require SSL mode.|
|ssl_mode |||null|Verify-ca SSL mode.|
|ssl_mode |||null|Verify-full SSL mode.|
|ssl_mode.mode 0|string|disable|null||
|ssl_mode.mode 1|string|allow|null||
|ssl_mode.mode 2|string|prefer|null||
|ssl_mode.mode 3|string|require|null||
|ssl_mode.mode 4|string|verify-ca|null||
|ssl_mode.ssl_ca_certificate 4|string||null|Specifies the file name of a PEM file that contains Certificate Authority (CA) certificates for use with SSLMODE=verify-ca.
 See more information - <a href="https://teradata-docs.s3.amazonaws.com/doc/connectivity/jdbc/reference/current/jdbcug_chapter_2.html#URL_SSLCA"> in the docs</a>.|
|ssl_mode.mode 5|string|verify-full|null||
|ssl_mode.ssl_ca_certificate 5|string||null|Specifies the file name of a PEM file that contains Certificate Authority (CA) certificates for use with SSLMODE=verify-full.
 See more information - <a href="https://teradata-docs.s3.amazonaws.com/doc/connectivity/jdbc/reference/current/jdbcug_chapter_2.html#URL_SSLCA"> in the docs</a>.|

# Source Teradata

This is the repository for the Teradata source connector in Java.
For information about how to use this connector within Airbyte, see [the User Documentation](https://docs.airbyte.com/integrations/sources/teradata).

## Local development

#### Building via Gradle
From the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-teradata:build
```

#### Create credentials
**If you are a community contributor**, generate the necessary credentials and place them in `secrets/config.json` conforming to the spec file in `src/main/resources/spec.json`.
Note that the `secrets` directory is git-ignored by default, so there is no danger of accidentally checking in sensitive information.

**If you are an Airbyte core member**, follow the [instructions](https://docs.airbyte.com/connector-development#using-credentials-in-ci) to set up the credentials.

### Locally running the connector docker image

#### Build
Build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-teradata:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-teradata:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-teradata:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-teradata:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-teradata:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```

## Testing
We use `JUnit` for Java tests.

### Unit and Integration Tests
Place unit tests under `src/test/...`
Place integration tests in `src/test-integration/...` 

#### Acceptance Tests
Airbyte has a standard test suite that all source connectors must pass. Implement the `TODO`s in
`src/test-integration/java/io/airbyte/integrations/sources/TeradataSourceAcceptanceTest.java`.

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:source-teradata:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-teradata:integrationTest
```

## Dependency Management

### Publishing a new version of the connector
You've checked out the repo, implemented a million dollar feature, and you're ready to share your changes with the world. Now what?
1. Make sure your changes are passing unit and integration tests.
1. Bump the connector version in `Dockerfile` -- just increment the value of the `LABEL io.airbyte.version` appropriately (we use [SemVer](https://semver.org/)).
1. Create a Pull Request.
1. Pat yourself on the back for being an awesome contributor.
1. Someone from Airbyte will take a look at your PR and iterate with you to merge it into master.
