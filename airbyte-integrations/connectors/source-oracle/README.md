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
  "username": "my_username",
  "password": "my_password",
  "schemas": ["my_schema"],
  "jdbc_url_params": "key1=value1&key2=value2",
  "encryption": {
    "encryption_method": "unencrypted"
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host |string||null|Hostname of the database.|
|port |integer||1521|Port of the database.
Oracle Corporations recommends the following port numbers:
1521 - Default listening port for client connections to the listener. 
2484 - Recommended and officially registered listening port for client connections to the listener using TCP/IP with SSL|
|username |string||null|The username which is used to access the database.|
|password |string||null|The password associated with the username.|
|schemas |array||null|The list of schemas to sync from. Defaults to user. Case sensitive.|
|jdbc_url_params |string||null|Additional properties to pass to the JDBC URL string when connecting to the database formatted as 'key=value' pairs separated by the symbol '&'. (example: key1=value1&key2=value2&key3=value3).|
|connection_data |||null|Use service name|
|connection_data |||null|Use SID (Oracle System Identifier)|
|connection_data.connection_type 0|string|service_name|null||
|connection_data.service_name 0|string||null||
|connection_data.connection_type 1|string|sid|null||
|connection_data.sid 1|string||null||
|encryption |||null|Data transfer will not be encrypted.|
|encryption |||null|The native network encryption gives you the ability to encrypt database connections, without the configuration overhead of TCP/IP and SSL/TLS and without the need to open and listen on different ports.|
|encryption |||null|Verify and use the certificate provided by the server.|
|encryption.encryption_method 0|string|unencrypted|null||
|encryption.encryption_method 1|string|client_nne|null||
|encryption.encryption_algorithm 1|string||AES256|This parameter defines what encryption algorithm is used.|
|encryption.encryption_method 2|string|encrypted_verify_certificate|null||
|encryption.ssl_certificate 2|string||null|Privacy Enhanced Mail (PEM) files are concatenated certificate containers frequently used in certificate installations.|

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
