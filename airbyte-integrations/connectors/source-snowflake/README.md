# Source snowflake

## Example
```
{
  "credentials": {
    "auth_type": "OAuth",
    "client_id": "CLIENT_ID",
    "client_secret": "CLIENT_SECRET",
    "access_token": "ACCESS_TOKEN",
    "refresh_token": "REFRESH_TOKEN"
  },
  "host": "accountname.us-east-2.aws.snowflakecomputing.com",
  "role": "AIRBYTE_ROLE",
  "warehouse": "AIRBYTE_WAREHOUSE",
  "database": "AIRBYTE_DATABASE",
  "schema": "AIRBYTE_SCHEMA",
  "jdbc_url_params": "key1=value1&key2=value2&key3=value3"
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host |string||null|The host domain of the snowflake instance (must include the account, region, cloud environment, and end with snowflakecomputing.com).|
|role |string||null|The role you created for Airbyte to access Snowflake.|
|warehouse |string||null|The warehouse you created for Airbyte to access data.|
|database |string||null|The database you created for Airbyte to access data.|
|schema |string||null|The source Snowflake schema tables. Leave empty to access tables from multiple schemas.|
|jdbc_url_params |string||null|Additional properties to pass to the JDBC URL string when connecting to the database formatted as 'key=value' pairs separated by the symbol '&'. (example: key1=value1&key2=value2&key3=value3).|
|credentials.auth_type 0|string|OAuth|null||
|credentials.client_id 0|string||null|The Client ID of your Snowflake developer application.|
|credentials.client_secret 0|string||null|The Client Secret of your Snowflake developer application.|
|credentials.access_token 0|string||null|Access Token for making authenticated requests.|
|credentials.refresh_token 0|string||null|Refresh Token for making authenticated requests.|
|credentials.auth_type 1|string|username/password|null||
|credentials.username 1|string||null|The username you created to allow Airbyte to access the database.|
|credentials.password 1|string||null|The password associated with the username.|

# Snowflake Source

## Documentation
* [User Documentation](https://docs.airbyte.io/integrations/sources/snowflake)

## Community Contributor
1. Look at the integration documentation to see how to create a warehouse/database/schema/user/role for Airbyte to sync into.
1. Create a file at `secrets/config.json` with the following format:
```
{
  "host": "ACCOUNT.REGION.PROVIDER.snowflakecomputing.com",
  "role": "AIRBYTE_ROLE",
  "warehouse": "AIRBYTE_WAREHOUSE",
  "database": "AIRBYTE_DATABASE",
  "schema": "AIRBYTE_SCHEMA",
  "credentials": {
    "auth_type": "username/password",
    "username": "AIRBYTE_USER",
    "password": "SOMEPASSWORD"
  }
}
```
3. Create a file at `secrets/config_auth.json` with the following format:
```
{
  "host": "ACCOUNT.REGION.PROVIDER.snowflakecomputing.com",
  "role": "AIRBYTE_ROLE",
  "warehouse": "AIRBYTE_WAREHOUSE",
  "database": "AIRBYTE_DATABASE",
  "schema": "AIRBYTE_SCHEMA",
  "credentials": {
    "auth_type": "OAuth",
    "client_id": "client_id",
    "client_secret": "client_secret",
    "refresh_token": "refresh_token"
  }
}
```
## For Airbyte employees
To be able to run integration tests locally:
1. Put the contents of the `Source snowflake test creds (secrets/config.json)` secret on Lastpass into `secrets/config.json`.
1. Put the contents of the `SECRET_SOURCE-SNOWFLAKE_OAUTH__CREDS (secrets/config_auth.json)` secret on Lastpass into `secrets/config_auth.json`.
