# Source senseforce

## Example
```
{
  "access_token": "your_api_access_token",
  "backend_url": "https://galaxyapi.senseforce.io",
  "dataset_id": "8f418098-ca28-4df5-9498-0df9fe78eda7",
  "start_date": "2020-10-10",
  "slice_range": 10
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|access_token|string||null|Your API access token. See <a href="https://manual.senseforce.io/manual/sf-platform/public-api/get-your-access-token/">here</a>. The toke is case sensitive.|
|backend_url|string||null|Your Senseforce API backend URL. This is the URL shown during the Login screen. See <a href="https://manual.senseforce.io/manual/sf-platform/public-api/get-your-access-token/">here</a> for more details. (Note: Most Senseforce backend APIs have the term 'galaxy' in their ULR)|
|dataset_id|string||null|The ID of the dataset you want to synchronize. The ID can be found in the URL when opening the dataset. See <a href="https://manual.senseforce.io/manual/sf-platform/public-api/get-your-access-token/">here</a> for more details. (Note: As the Senseforce API only allows to synchronize a specific dataset, each dataset you  want to synchronize needs to be implemented as a separate airbyte source).|
|start_date|string||null|UTC date and time in the format 2017-01-25. Only data with "Timestamp" after this date will be replicated. Important note: This start date must be set to the first day of where your dataset provides data.  If your dataset has data from 2020-10-10 10:21:10, set the start_date to 2020-10-10 or later|
|slice_range|integer||10|The time increment used by the connector when requesting data from the Senseforce API. The bigger the value is, the less requests will be made and faster the sync will be. On the other hand, the more seldom the state is persisted and the more likely one could run into rate limites.  Furthermore, consider that large chunks of time might take a long time for the Senseforce query to return data - meaning it could take in effect longer than with more smaller time slices. If there are a lot of data per day, set this setting to 1. If there is only very little data per day, you might change the setting to 10 or more.|

# Senseforce Source

This is the repository for the Senseforce configuration based source connector.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/senseforce).

## Local development

#### Building via Gradle
You can also build the connector in Gradle. This is typically used in CI and not needed for your development workflow.

To build using Gradle, from the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-senseforce:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/senseforce)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_senseforce/spec.yaml` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source senseforce test creds`
and place them into `secrets/config.json`.

### Locally running the connector docker image

#### Build
First, make sure you build the latest Docker image:
```
docker build . -t airbyte/source-senseforce:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-senseforce:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-senseforce:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-senseforce:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-senseforce:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-senseforce:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
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
./gradlew :airbyte-integrations:connectors:source-senseforce:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-senseforce:integrationTest
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
