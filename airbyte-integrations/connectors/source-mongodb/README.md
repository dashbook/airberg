# Source mongodb

## Example
```
{
  "host": "localhost",
  "port": 27017,
  "database": "mydb",
  "user": "myuser",
  "password": "mypassword",
  "auth_source": "admin",
  "replica_set": "",
  "ssl": false
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|host |string||null|Host of a Mongo database to be replicated.|
|port |integer||27017|Port of a Mongo database to be replicated.|
|database |string||null|Database to be replicated.|
|user |string||null|User|
|password |string||null|Password|
|auth_source |string||admin|Authentication source where user information is stored. See <a href="* [Authentication Source](https://docs.mongodb.com/manual/reference/connection-string/#mongodb-urioption-urioption.authSource)"> the Mongo docs</a> for more info.|
|replica_set |string|||The name of the set to filter servers by, when connecting to a replica set (Under this condition, the 'TLS connection' value automatically becomes 'true'). See <a href="https://docs.mongodb.com/manual/reference/connection-string/#mongodb-urioption-urioption.replicaSet"> the Mongo docs </a> for more info.|
|ssl |boolean||false|If this switch is enabled, TLS connections will be used to connect to MongoDB.|

# Mongodb Source 

This is the repository for the Mongodb source connector, written in Ruby. 

## Local development
### Requirements

#### Ruby Version
This module uses `rbenv` to manage its Ruby version. If you have `rbenv` installed, you should be running the correct Ruby version. 

While it is _highly_ recommended to use `rbenv`, if you don't want to, just make sure your system is running whatever ruby version is present in the file `.ruby-version`.

#### Install dependencies
1. Install the correct `bundle` version (found at the bottom of `Gemfile`). Currently this is `gem install bundle:2.2.3`. 
2. `bundle install`

### Local iteration
1. Change code
2. `ruby source.rb <args>`

For example, to verify if your provided credentials are valid and can be used to connect to a mongo DB, run: 
```
ruby source.rb check --config <path_to_your_config.json> 
```

The full list of commands are: 

1. `ruby source.rb spec`
2. `ruby source.rb check --config <config_path>`
3. `ruby source.rb discover --config <config_path>`
4. `ruby source.rb read --config <config_path> --catalog <configured_catalog_path> [--state <state_path>]`

These commands correspond to the ones in the [Airbyte Protocol]().

### Build connector Docker image
First, build the module by running the following from the airbyte project root directory: 
```
cd airbyte-integrations/connectors/source-mongodb/
docker build . -t airbyte/source-mongodb:dev
```

### Integration Tests 
From the airbyte project root, run:
```
./gradlew clean :airbyte-integrations:connectors:source-mongodb:integrationTest
```

## Configure credentials
Create a `secrets` folder (which is gitignored by default) and place your credentials as a JSON file in it. An example of the needed credentials is available in `integration_tests/valid_config.json`. 

## Discover phase
MongoDB does not have anything like table definition, thus we have to define column types from actual attributes and their values. Discover phase have two steps:

### Step 1. Find all unique properties
Connector runs the map-reduce command which returns all unique document props in the collection. Map-reduce approach should be sufficient even for large clusters.

### Step 2. Determine property types
For each property found, connector selects 10k documents from the collection where this property is not empty. If all the selected values have the same type - connector will set appropriate type to the property. In all other cases connector will fallback to `string` type.

## Author
This connector was authored by [Yury Koleda](https://github.com/FUT).
