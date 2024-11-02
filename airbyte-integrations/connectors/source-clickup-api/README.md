# Source clickup-api

## Example
```json
{
  "api_token": "YourPersonalAPIToken",
  "team_id": "YourTeamID",
  "space_id": "YourSpaceID",
  "folder_id": "YourFolderID",
  "list_id": "YourListID",
  "include_closed_tasks": true
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|api_token |string||null|Every ClickUp API call required authentication. This field is your personal API token. See <a href="https://clickup.com/api/developer-portal/authentication/#personal-token">here</a>.|
|team_id |string||null|The ID of your team in ClickUp. Retrieve it from the `/team` of the ClickUp API. See <a href="https://clickup.com/api/clickupreference/operation/GetAuthorizedTeams/">here</a>.|
|space_id |string||null|The ID of your space in your workspace. Retrieve it from the `/team/{team_id}/space` of the ClickUp API. See <a href="https://clickup.com/api/clickupreference/operation/GetSpaces/">here</a>.|
|folder_id |string||null|The ID of your folder in your space. Retrieve it from the `/space/{space_id}/folder` of the ClickUp API. See <a href="https://clickup.com/api/clickupreference/operation/GetFolders/">here</a>.|
|list_id |string||null|The ID of your list in your folder. Retrieve it from the `/folder/{folder_id}/list` of the ClickUp API. See <a href="https://clickup.com/api/clickupreference/operation/GetLists/">here</a>.|
|include_closed_tasks |boolean||false|Include or exclude closed tasks. By default, they are excluded. See <a https://clickup.com/api/clickupreference/operation/GetTasks/#!in=query&path=include_closed&t=request">here</a>.|

# Clickup Api Source

This is the repository for the Clickup Api configuration based source connector.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/clickup-api).

## Local development

#### Building via Gradle
You can also build the connector in Gradle. This is typically used in CI and not needed for your development workflow.

To build using Gradle, from the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-clickup-api:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/clickup-api)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_clickup_api/spec.yaml` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source clickup-api test creds`
and place them into `secrets/config.json`.

### Locally running the connector docker image

#### Build
First, make sure you build the latest Docker image:
```
docker build . -t airbyte/source-clickup-api:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-clickup-api:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-clickup-api:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-clickup-api:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-clickup-api:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-clickup-api:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
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
./gradlew :airbyte-integrations:connectors:source-clickup-api:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-clickup-api:integrationTest
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
