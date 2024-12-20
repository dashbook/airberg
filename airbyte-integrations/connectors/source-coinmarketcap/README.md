# Source coinmarketcap

## Example
```json
{
  "api_key": "your_api_key_here",
  "data_type": "historical",
  "symbols": ["AVAX", "BTC"]
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|api_key |string||null|Your API Key. See <a href="https://coinmarketcap.com/api/documentation/v1/#section/Authentication">here</a>. The token is case sensitive.|
|data_type |string||null|/latest: Latest market ticker quotes and averages for cryptocurrencies and exchanges. /historical: Intervals of historic market data like OHLCV data or data for use in charting libraries. See <a href="https://coinmarketcap.com/api/documentation/v1/#section/Endpoint-Overview">here</a>.|
|symbols |array||null|Cryptocurrency symbols. (only used for quotes stream)|

# Coinmarketcap Source

This is the repository for the Coinmarketcap configuration based source connector.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/coinmarketcap).

## Local development

#### Building via Gradle
You can also build the connector in Gradle. This is typically used in CI and not needed for your development workflow.

To build using Gradle, from the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-coinmarketcap:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/coinmarketcap)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_coinmarketcap/spec.yaml` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source coinmarketcap test creds`
and place them into `secrets/config.json`.

### Locally running the connector docker image

#### Build
First, make sure you build the latest Docker image:
```
docker build . -t airbyte/source-coinmarketcap:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-coinmarketcap:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-coinmarketcap:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-coinmarketcap:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-coinmarketcap:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-coinmarketcap:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
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
./gradlew :airbyte-integrations:connectors:source-coinmarketcap:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-coinmarketcap:integrationTest
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
