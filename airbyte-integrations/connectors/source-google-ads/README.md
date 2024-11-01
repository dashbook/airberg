# Source google-ads

## Example
```json
{
  "credentials": {
    "developer_token": "your_developer_token",
    "client_id": "your_client_id",
    "client_secret": "your_client_secret",
    "refresh_token": "your_refresh_token",
    "access_token": "your_access_token"
  },
  "customer_id": "6783948572",
  "start_date": "2022-01-01",
  "end_date": "2022-01-31",
  "custom_queries": [
    {
      "query": "SELECT segments.ad_destination_type, campaign.advertising_channel_sub_type FROM campaign WHERE campaign.status = 'PAUSED'",
      "table_name": "your_table_name"
    }
  ],
  "login_customer_id": "7349206847",
  "conversion_window_days": 14
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|customer_id|string||null|Comma separated list of (client) customer IDs. Each customer ID must be specified as a 10-digit number without dashes. More instruction on how to find this value in our <a href="https://docs.airbyte.com/integrations/sources/google-ads#setup-guide">docs</a>. Metrics streams like AdGroupAdReport cannot be requested for a manager account.|
|start_date|string||null|UTC date and time in the format 2017-01-25. Any data before this date will not be replicated.|
|end_date|string||null|UTC date and time in the format 2017-01-25. Any data after this date will not be replicated.|
|custom_queries|array||null||
|login_customer_id|string||null|If your access to the customer account is through a manager account, this field is required and must be set to the customer ID of the manager account (10-digit number without dashes). More information about this field you can see <a href="https://developers.google.com/google-ads/api/docs/concepts/call-structure#cid">here</a>|
|conversion_window_days|integer||14|A conversion window is the period of time after an ad interaction (such as an ad click or video view) during which a conversion, such as a purchase, is recorded in Google Ads. For more information, see Google's <a href="https://support.google.com/google-ads/answer/3123169?hl=en">documentation</a>.|
|credentials.developer_token|string||null|Developer token granted by Google to use their APIs. More instruction on how to find this value in our <a href="https://docs.airbyte.com/integrations/sources/google-ads#setup-guide">docs</a>|
|credentials.client_id|string||null|The Client ID of your Google Ads developer application. More instruction on how to find this value in our <a href="https://docs.airbyte.com/integrations/sources/google-ads#setup-guide">docs</a>|
|credentials.client_secret|string||null|The Client Secret of your Google Ads developer application. More instruction on how to find this value in our <a href="https://docs.airbyte.com/integrations/sources/google-ads#setup-guide">docs</a>|
|credentials.refresh_token|string||null|The token for obtaining a new access token. More instruction on how to find this value in our <a href="https://docs.airbyte.com/integrations/sources/google-ads#setup-guide">docs</a>|
|credentials.access_token|string||null|Access Token for making authenticated requests. More instruction on how to find this value in our <a href="https://docs.airbyte.com/integrations/sources/google-ads#setup-guide">docs</a>|
|custom_queries.items.query|string||null|A custom defined GAQL query for building the report. Should not contain segments.date expression because it is used by incremental streams. See Google's <a href="https://developers.google.com/google-ads/api/fields/v11/overview_query_builder">query builder</a> for more information.|
|custom_queries.items.table_name|string||null|The table name in your destination database for choosen query.|

# Google Ads Source

This is the repository for the Google Ads source connector, written in Python.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/google-ads).

## Local development

### Prerequisites
**To iterate on this connector, make sure to complete this prerequisites section.**

#### Build & Activate Virtual Environment and install dependencies
From this connector directory, create a virtual environment:
```
python -m venv .venv
```

This will generate a virtualenv for this module in `.venv/`. Make sure this venv is active in your
development environment of choice. To activate it from the terminal, run:
```
source .venv/bin/activate
pip install -r requirements.txt
```
If you are in an IDE, follow your IDE's instructions to activate the virtualenv.

Note that while we are installing dependencies from `requirements.txt`, you should only edit `setup.py` for your dependencies. `requirements.txt` is
used for editable installs (`pip install -e`) to pull in Python dependencies from the monorepo and will call `setup.py`.
If this is mumbo jumbo to you, don't worry about it, just put your deps in `setup.py` but install using `pip install -r requirements.txt` and everything
should work as you expect.

#### Building via Gradle
You can also build the connector in Gradle. This is typically used in CI and not needed for your development workflow.

To build using Gradle, from the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-google-ads:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/google-ads)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_google_ads/spec.json` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source google-ads test creds`
and place them into `secrets/config.json`.

### Locally running the connector
```
python main.py spec
python main.py check --config secrets/config.json
python main.py discover --config secrets/config.json
python main.py read --config secrets/config.json --catalog integration_tests/configured_catalog.json
```

### Locally running the connector docker image

#### Build
First, make sure you build the latest Docker image:
```
docker build . -t airbyte/source-google-ads:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-google-ads:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-google-ads:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-google-ads:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-google-ads:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-google-ads:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```
## Testing
Make sure to familiarize yourself with [pytest test discovery](https://docs.pytest.org/en/latest/goodpractices.html#test-discovery) to know how your test files and methods should be named.
First install test dependencies into your virtual environment:
```
pip install -e '.[tests]'
```
### Unit Tests
To run unit tests locally, from the connector directory run:
```
python -m pytest unit_tests
```

### Integration Tests
There are two types of integration tests: Acceptance Tests (Airbyte's test suite for all source connectors) and custom integration tests (which are specific to this connector).
#### Custom Integration tests
Place custom tests inside `integration_tests/` folder, then, from the connector root, run
```
python -m pytest integration_tests
```
#### Acceptance Tests
Customize `acceptance-test-config.yml` file to configure tests. See [Connector Acceptance Tests](https://docs.airbyte.io/connector-development/testing-connectors/connector-acceptance-tests-reference) for more information.
If your connector requires to create or destroy resources for use during acceptance tests create fixtures for it and place them inside integration_tests/acceptance.py.
To run your integration tests with acceptance tests, from the connector root, run
```
python -m pytest integration_tests -p integration_tests.acceptance
```
To run your integration tests with docker

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:source-google-ads:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-google-ads:integrationTest
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
