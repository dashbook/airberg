# Source db2

## Example
```json
{
  "host": "localhost",
  "port": 50000,
  "db": "mydb",
  "username": "myuser",
  "password": "mypassword",
  "jdbc_url_params": "param1=value1&param2=value2",
  "encryption": {
    "encryption_method": "encrypted_verify_certificate",
    "ssl_certificate": "-----BEGIN CERTIFICATE-----...-----END CERTIFICATE-----",
    "key_store_password": "mykeystorepassword"
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host|string||null|Host of the Db2.|
|port|integer||8123|Port of the database.|
|db|string||null|Name of the database.|
|username|string||null|Username to use to access the database.|
|password|string||null|Password associated with the username.|
|jdbc_url_params|string||null|Additional properties to pass to the JDBC URL string when connecting to the database formatted as 'key=value' pairs separated by the symbol '&'. (example: key1=value1&key2=value2&key3=value3).|
|encryption|object||null|Encryption method to use when communicating with the database|
|encryption.0.encryption_method|string|unencrypted|null||
|encryption.1.encryption_method|string|encrypted_verify_certificate|null||
|encryption.1.ssl_certificate|string||null|Privacy Enhanced Mail (PEM) files are concatenated certificate containers frequently used in certificate installations|
|encryption.1.key_store_password|string||null|Key Store Password|

# IBM DB2 Source

## Documentation
* [User Documentation](https://docs.airbyte.io/integrations/sources/db2)


## Integration tests
For acceptance tests run

`./gradlew :airbyte-integrations:connectors:db2:integrationTest`