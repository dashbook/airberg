# Source oura

## Example
```json
{
  "api_key": "1234567890",
  "start_datetime": "2022-01-01T00:00:00Z",
  "end_datetime": "2022-01-31T23:59:59Z"
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|api_key |string||null|API Key|
|start_datetime |string||null|Start datetime to sync from. Default is current UTC datetime minus 1
day.
|
|end_datetime |string||null|End datetime to sync until. Default is current UTC datetime.|

# Oura Source

This is the repository for the Oura configuration based source connector.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/oura).

## Local development

#### Building via Gradle
You can also build the connector in Gradle. This is typically used in CI and not needed for your development workflow.

To build using Gradle, from the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-oura:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/oura)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_oura/spec.yaml` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source oura test creds`
and place them into `secrets/config.json`.

### Locally running the connector docker image

#### Build
First, make sure you build the latest Docker image:
```
docker build . -t airbyte/source-oura:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-oura:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-oura:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-oura:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-oura:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-oura:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```
## Testing

#### Acceptance Tests
Customize `acceptance-test-config.yml` file to configure tests. See [Connector Acceptance Tests](https://docs.airbyte.io/connector-development/testing-connectors/connector-acceptance-tests-reference) for more information.
If your connector requires to create or destroy resources for use during acceptance tests create fixtures for it and place them inside integration_tests/acceptance.py.

To run your integration tests with docker

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:source-oura:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-oura:integrationTest
```

## Dependency Management
All of your dependencies should go in `setup.py`, NOT `requirements.txt`. The requirements file is only used to connect internal Airbyte dependencies in the monorepo for local development.
We split dependencies between two groups, dependencies that are:
* required for your connector to work need to go to `MAIN_REQUIREMENTS` list.
* required for the testing need to go to `TEST_REQUIREMENTS` list

### Publishing a new version of the connector
You've checked out the repo, implemented a million dollar feature, and you're ready to share your changes with the world. Now what?
1. Make sure your changes are passing unit and integration tests.
1. Bump the connector version in `Dockerfile` -- just increment the value of the `LABEL io.airbyte.version` appropriately (we use [SemVer](https://semver.org/)).
1. Create a Pull Request.
1. Pat yourself on the back for being an awesome contributor.
1. Someone from Airbyte will take a look at your PR and iterate with you to merge it into master.
