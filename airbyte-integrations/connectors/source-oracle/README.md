# Source oracle

## Example
```json
{
  "host": "localhost",
  "port": 1521,
  "connection_data": {
    "connection_type": "service_name",
    "service_name": "my_service"
  },
  "username": "my_user",
  "password": "my_password",
  "schemas": ["my_schema"],
  "jdbc_url_params": "param1=value1&param2=value2",
  "encryption": {
    "encryption_method": "encrypted_verify_certificate",
    "ssl_certificate": "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host|string||null|Hostname of the database.|
|port|integer||1521|Port of the database.
Oracle Corporations recommends the following port numbers:
1521 - Default listening port for client connections to the listener. 
2484 - Recommended and officially registered listening port for client connections to the listener using TCP/IP with SSL|
|connection_data|object||null|Connect data that will be used for DB connection|
|username|string||null|The username which is used to access the database.|
|password|string||null|The password associated with the username.|
|schemas|array||null|The list of schemas to sync from. Defaults to user. Case sensitive.|
|jdbc_url_params|string||null|Additional properties to pass to the JDBC URL string when connecting to the database formatted as 'key=value' pairs separated by the symbol '&'. (example: key1=value1&key2=value2&key3=value3).|
|encryption|object||null|The encryption method with is used when communicating with the database.|
|connection_data.0.connection_type|string|service_name|null||
|connection_data.0.service_name|string||null||
|connection_data.1.connection_type|string|sid|null||
|connection_data.1.sid|string||null||
|encryption.0.encryption_method|string|unencrypted|null||
|encryption.1.encryption_method|string|client_nne|null||
|encryption.1.encryption_algorithm|string||AES256|This parameter defines what encryption algorithm is used.|
|encryption.2.encryption_method|string|encrypted_verify_certificate|null||
|encryption.2.ssl_certificate|string||null|Privacy Enhanced Mail (PEM) files are concatenated certificate containers frequently used in certificate installations.|

# Oracle Source

## Documentation
This is the repository for the Oracle only source connector in Java.
For information about how to use this connector within Airbyte, see [User Documentation](https://docs.airbyte.io/integrations/sources/oracle)

## Local development

#### Building via Gradle
From the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-oracle:build
```

### Locally running the connector docker image

#### Build
Build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-oracle:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

## Testing
We use `JUnit` for Java tests.

### Test Configuration
#### Acceptance Tests
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-oracle:integrationTest
```
