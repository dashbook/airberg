# Source google-analytics-data-api

## Example
```json
{
  "credentials": {
    "auth_type": "Client",
    "client_id": "1234567890",
    "client_secret": "abcdefg",
    "refresh_token": "refresh_token_value",
    "access_token": "access_token_value"
  },
  "property_id": "1234567890",
  "date_ranges_start_date": "2021-01-01",
  "custom_reports": "{\"report_id\":\"report_id_value\",\"date_ranges_start_date\":\"2021-01-01\",\"dimensions\":[{\"name\":\"dimension_name\",\"field_name\":\"dimension_field_name\"}]}",
  "window_in_days": 30
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|credentials|object||null|Credentials for the service|
|property_id|string||null|A Google Analytics GA4 property identifier whose events are tracked. Specified in the URL path and not the body such as "123...". See <a href="https://developers.google.com/analytics/devguides/reporting/data/v1/property-id#what_is_my_property_id">the docs</a> for more details.|
|date_ranges_start_date|string||null|The start date from which to replicate report data in the format YYYY-MM-DD. Data generated before this date will not be included in the report. Not applied to custom Cohort reports.|
|custom_reports|string||null|A JSON array describing the custom reports you want to sync from Google Analytics. See <a href="https://docs.airbyte.com/integrations/sources/google-analytics-v4/#custom-reports">the docs</a> for more information about the exact format you can use to fill out this field.|
|window_in_days|integer||1|The time increment used by the connector when requesting data from the Google Analytics API. More information is available in the <a href="https://docs.airbyte.com/integrations/sources/google-analytics-v4/#sampling-in-reports">the docs</a>. The bigger this value is, the faster the sync will be, but the more likely that sampling will be applied to your data, potentially causing inaccuracies in the returned results. We recommend setting this to 1 unless you have a hard requirement to make the sync faster at the expense of accuracy. The minimum allowed value for this field is 1, and the maximum is 364. Not applied to custom Cohort reports.|
|credentials.0.auth_type|string|Client|null||
|credentials.0.client_id|string||null|The Client ID of your Google Analytics developer application.|
|credentials.0.client_secret|string||null|The Client Secret of your Google Analytics developer application.|
|credentials.0.refresh_token|string||null|The token for obtaining a new access token.|
|credentials.0.access_token|string||null|Access Token for making authenticated requests.|
|credentials.1.auth_type|string|Service|null||
|credentials.1.credentials_json|string||null|The JSON key of the service account to use for authorization|

# Google Analytics Data Api Source

This is the repository for the Google Analytics Data Api source connector, written in Python.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/google-analytics-data-api).

## Local development

### Prerequisites
**To iterate on this connector, make sure to complete this prerequisites section.**

#### Minimum Python version required `= 3.7.0`

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
From the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-google-analytics-data-api:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/google-analytics-data-api)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_google_analytics_data_api/spec.{yaml,json}` file.
Note that the `secrets` directory is gitignored by default, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source google-analytics-data-api test creds`
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
docker build . -t airbyte/source-google-analytics-data-api:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-google-analytics-data-api:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-google-analytics-data-api:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-google-analytics-data-api:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-google-analytics-data-api:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-google-analytics-data-api:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```
## Testing
   Make sure to familiarize yourself with [pytest test discovery](https://docs.pytest.org/en/latest/goodpractices.html#test-discovery) to know how your test files and methods should be named.
First install test dependencies into your virtual environment:
```
pip install '.[tests]'
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
docker build . --no-cache -t airbyte/source-google-analytics-data-api:dev \
&& python -m pytest -p connector_acceptance_test.plugin
```
To run your integration tests with docker

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:source-google-analytics-data-api:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-google-analytics-data-api:integrationTest
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
