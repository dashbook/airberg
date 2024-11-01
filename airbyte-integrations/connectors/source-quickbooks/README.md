# Source quickbooks

## Example
```json
{
  "credentials": {
    "auth_type": "oauth2.0",
    "client_id": "abc123",
    "client_secret": "xyz789",
    "refresh_token": "1234567890",
    "access_token": "abcdefghij",
    "token_expiry_date": "2022-01-01T00:00:00Z",
    "realm_id": "qwerty"
  },
  "start_date": "2021-03-20T00:00:00Z",
  "sandbox": true
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|credentials|object||null||
|start_date|string||null|The default value to use if no bookmark exists for an endpoint (rfc3339 date string). E.g, 2021-03-20T00:00:00Z. Any data before this date will not be replicated.|
|sandbox|boolean||false|Determines whether to use the sandbox or production environment.|
|credentials.0.auth_type|string|oauth2.0|null||
|credentials.0.client_id|string||null|Identifies which app is making the request. Obtain this value from the Keys tab on the app profile via My Apps on the developer site. There are two versions of this key: development and production.|
|credentials.0.client_secret|string||null| Obtain this value from the Keys tab on the app profile via My Apps on the developer site. There are two versions of this key: development and production.|
|credentials.0.refresh_token|string||null|A token used when refreshing the access token.|
|credentials.0.access_token|string||null|Access token fot making authenticated requests.|
|credentials.0.token_expiry_date|string||null|The date-time when the access token should be refreshed.|
|credentials.0.realm_id|string||null|Labeled Company ID. The Make API Calls panel is populated with the realm id and the current access token.|

# Quickbooks Source

This is the repository for the Quickbooks configuration based source connector.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.com/integrations/sources/quickbooks).

## Local development

#### Building via Gradle
You can also build the connector in Gradle. This is typically used in CI and not needed for your development workflow.

To build using Gradle, from the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-quickbooks:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.com/integrations/sources/quickbooks)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_quickbooks/spec.yaml` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source quickbooks test creds`
and place them into `secrets/config.json`.

### Locally running the connector docker image

#### Build
First, make sure you build the latest Docker image:
```
docker build . -t airbyte/source-quickbooks:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-quickbooks:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-quickbooks:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-quickbooks:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-quickbooks:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-quickbooks:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```
## Testing

#### Acceptance Tests
Customize `acceptance-test-config.yml` file to configure tests. See [Connector Acceptance Tests](https://docs.airbyte.com/connector-development/testing-connectors/connector-acceptance-tests-reference) for more information.
If your connector requires to create or destroy resources for use during acceptance tests create fixtures for it and place them inside integration_tests/acceptance.py.

To run your integration tests with Docker, run:
```
./acceptance-test-docker.sh
```

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:source-quickbooks:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-quickbooks:integrationTest
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
