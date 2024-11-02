# Source dynamodb

## Example
```
{
  "endpoint": "https://dynamodb.us-east-1.amazonaws.com",
  "region": "us-east-1",
  "access_key_id": "A012345678910EXAMPLE",
  "secret_access_key": "a012345678910ABCDEFGH/AbCdEfGhEXAMPLEKEY",
  "reserved_attribute_names": "name, field_name, field-name"
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|endpoint |string|||the URL of the Dynamodb database|
|region |string|||The region of the Dynamodb database|
|access_key_id |string||null|The access key id to access Dynamodb. Airbyte requires read permissions to the database|
|secret_access_key |string||null|The corresponding secret to the access key id.|
|reserved_attribute_names |string||null|Comma separated reserved attribute names present in your tables|

# Source Dynamodb

This is the repository for the Dynamodb source connector in Java.
For information about how to use this connector within Airbyte, see [the User Documentation](https://docs.airbyte.io/integrations/sources/dynamodb).

## Local development

#### Building via Gradle
From the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-dynamodb:build
```

#### Create credentials
**If you are a community contributor**, generate the necessary credentials and place them in `secrets/config.json` conforming to the spec file in `src/main/resources/spec.json`.
Note that the `secrets` directory is git-ignored by default, so there is no danger of accidentally checking in sensitive information.

**If you are an Airbyte core member**, follow the [instructions](https://docs.airbyte.io/connector-development#using-credentials-in-ci) to set up the credentials.

### Locally running the connector docker image

#### Build
Build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-dynamodb:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-dynamodb:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-dynamodb:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-dynamodb:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-dynamodb:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```

## Testing
We use `JUnit` for Java tests.

### Unit and Integration Tests
Place unit tests under `src/test/...`
Place integration tests in `src/test-integration/...` 

#### Acceptance Tests
Airbyte has a standard test suite that all source connectors must pass. Implement the `TODO`s in
`src/test-integration/java/io/airbyte/integrations/sources/dynamodbSourceAcceptanceTest.java`.

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:source-dynamodb:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-dynamodb:integrationTest
```

## Dependency Management

### Publishing a new version of the connector
You've checked out the repo, implemented a million dollar feature, and you're ready to share your changes with the world. Now what?
1. Make sure your changes are passing unit and integration tests.
1. Bump the connector version in `Dockerfile` -- just increment the value of the `LABEL io.airbyte.version` appropriately (we use [SemVer](https://semver.org/)).
1. Create a Pull Request.
1. Pat yourself on the back for being an awesome contributor.
1. Someone from Airbyte will take a look at your PR and iterate with you to merge it into master.
