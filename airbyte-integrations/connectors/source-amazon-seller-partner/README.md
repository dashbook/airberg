# Source amazon-seller-partner

## Example
{
  "aws_environment": "PRODUCTION",
  "region": "US",
  "aws_access_key": "YOUR_AWS_ACCESS_KEY",
  "aws_secret_key": "YOUR_AWS_SECRET_KEY",
  "role_arn": "YOUR_ROLE_ARN",
  "lwa_app_id": "YOUR_LWA_APP_ID",
  "lwa_client_secret": "YOUR_LWA_CLIENT_SECRET",
  "refresh_token": "YOUR_REFRESH_TOKEN",
  "replication_start_date": "2017-01-25T00:00:00Z",
  "replication_end_date": "2017-01-25T00:00:00Z",
  "period_in_days": 90,
  "report_options": "{\"GET_BRAND_ANALYTICS_SEARCH_TERMS_REPORT\": {\"reportPeriod\": \"WEEK\"}}",
  "max_wait_seconds": 500,
  "advanced_stream_options": "{\"GET_SALES_AND_TRAFFIC_REPORT\": {\"availability_sla_days\": 3}}"
}

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|auth_type |string|oauth2.0|null||
|aws_environment |string||PRODUCTION|Select the AWS Environment.|
|region |string||US|Select the AWS Region.|
|aws_access_key |string||null|Specifies the AWS access key used as part of the credentials to authenticate the user.|
|aws_secret_key |string||null|Specifies the AWS secret key used as part of the credentials to authenticate the user.|
|role_arn |string||null|Specifies the Amazon Resource Name (ARN) of an IAM role that you want to use to perform operations requested using this profile. (Needs permission to 'Assume Role' STS).|
|lwa_app_id |string||null|Your Login with Amazon Client ID.|
|lwa_client_secret |string||null|Your Login with Amazon Client Secret.|
|refresh_token |string||null|The Refresh Token obtained via OAuth flow authorization.|
|replication_start_date |string||null|UTC date and time in the format 2017-01-25T00:00:00Z. Any data before this date will not be replicated.|
|replication_end_date |string||null|UTC date and time in the format 2017-01-25T00:00:00Z. Any data after this date will not be replicated.|
|period_in_days |integer||90|Will be used for stream slicing for initial full_refresh sync when no updated state is present for reports that support sliced incremental sync.|
|report_options |string||null|Additional information passed to reports. This varies by report type. Must be a valid json string.|
|max_wait_seconds |integer||500|Sometimes report can take up to 30 minutes to generate. This will set the limit for how long to wait for a successful report.|
|advanced_stream_options |string||null|Additional information to configure report options. This varies by report type, not every report implement this kind of feature. Must be a valid json string.|

# Amazon Seller-Partner Source

This is the repository for the Amazon Seller-Partner source connector, written in Python.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/amazon-seller-partner).

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
From the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-amazon-seller-partner:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/amazon-seller-partner)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_amazon_seller-partner/integration_tests/spec.json` file.
Note that the `secrets` directory is gitignored by default, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source amazon-seller-partner test creds`
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
docker build . -t airbyte/source-amazon-seller-partner:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-amazon-seller-partner:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-amazon-seller-partner:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-amazon-seller-partner:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-amazon-seller-partner:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-amazon-seller-partner:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```
## Testing
   Make sure to familiarize yourself with [pytest test discovery](https://docs.pytest.org/en/latest/goodpractices.html#test-discovery) to know how your test files and methods should be named.
First install test dependencies into your virtual environment:
```
pip install .'[tests]'
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
./gradlew :airbyte-integrations:connectors:source-amazon-seller-partner:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-amazon-seller-partner:integrationTest
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
