# Source mongodb-v2

## Example
```json
{
  "database": "my_database",
  "user": "my_user",
  "password": "my_password",
  "auth_source": "my_auth_source",
  "instance_type": {
    "instance": "atlas",
    "cluster_url": "https://cluster-url.mongodb.net"
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|database |string||null|The database you want to replicate.|
|user |string||null|The username which is used to access the database.|
|password |string||null|The password associated with this username.|
|auth_source |string||admin|The authentication source where the user information is stored.|
|instance_type |||null||
|instance_type |||null||
|instance_type |||null||
|instance_type.instance 0|string|standalone|null||
|instance_type.host 0|string||null|The host name of the Mongo database.|
|instance_type.port 0|integer||27017|The port of the Mongo database.|
|instance_type.tls 0|boolean||false|Indicates whether TLS encryption protocol will be used to connect to MongoDB. It is recommended to use TLS connection if possible. For more information see <a href="https://docs.airbyte.com/integrations/sources/mongodb-v2">documentation</a>.|
|instance_type.instance 1|string|replica|null||
|instance_type.server_addresses 1|string||null|The members of a replica set. Please specify `host`:`port` of each member separated by comma.|
|instance_type.replica_set 1|string||null|A replica set in MongoDB is a group of mongod processes that maintain the same data set.|
|instance_type.instance 2|string|atlas|null||
|instance_type.cluster_url 2|string||null|The URL of a cluster to connect to.|

# MongoDb Source

## Documentation
This is the repository for the MongoDb source connector in Java.
For information about how to use this connector within Airbyte, see [User Documentation](https://docs.airbyte.io/integrations/sources/mongodb-v2)

## Local development

#### Building via Gradle
From the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-mongodb-v2:build
```

### Locally running the connector docker image

#### Build
Build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-mongodb-v2:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

## Testing
We use `JUnit` for Java tests.

### Test Configuration

No specific configuration needed for testing Standalone MongoDb instance, MongoDb Test Container is used.
In order to test the MongoDb Atlas or Replica set, you need to provide configuration parameters.

## Community Contributor

As a community contributor, you will need to have an Atlas cluster to test MongoDb source.

1. Create `secrets/credentials.json` file
   1. Insert below json to the file with your configuration
       ```
      {
         "database": "database_name",
         "user": "user",
         "password": "password",
         "cluster_url": "cluster_url"
       }
      ```

## Airbyte Employee

1. Access the `MONGODB_TEST_CREDS` secret on LastPass
1. Create a file with the contents at `secrets/credentials.json`


#### Acceptance Tests
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-mongodb-v2:integrationTest
```
