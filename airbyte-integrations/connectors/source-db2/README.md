# Source db2

## Example
```json
{
  "host": "localhost",
  "port": 8123,
  "db": "default",
  "username": "username",
  "password": "password",
  "jdbc_url_params": "key1=value1&key2=value2&key3=value3",
  "encryption": {
    "encryption_method": "unencrypted"
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host |string||null|Host of the Db2.|
|port |integer||8123|Port of the database.|
|db |string||null|Name of the database.|
|username |string||null|Username to use to access the database.|
|password |string||null|Password associated with the username.|
|jdbc_url_params |string||null|Additional properties to pass to the JDBC URL string when connecting to the database formatted as 'key=value' pairs separated by the symbol '&'. (example: key1=value1&key2=value2&key3=value3).|
|encryption |||null|Data transfer will not be encrypted.|
|encryption |||null|Verify and use the cert provided by the server.|
|encryption.encryption_method 0|string|unencrypted|null||
|encryption.encryption_method 1|string|encrypted_verify_certificate|null||
|encryption.ssl_certificate 1|string||null|Privacy Enhanced Mail (PEM) files are concatenated certificate containers frequently used in certificate installations|
|encryption.key_store_password 1|string||null|Key Store Password|

# IBM DB2 Source

## Documentation
* [User Documentation](https://docs.airbyte.io/integrations/sources/db2)


## Integration tests
For acceptance tests run

`./gradlew :airbyte-integrations:connectors:db2:integrationTest`