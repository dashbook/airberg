# Source facebook-marketing

## Example


## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|account_id|string||null|The Facebook Ad account ID to use when pulling data from the Facebook Marketing API. Open your Meta Ads Manager. The Ad account ID number is in the account dropdown menu or in your browser's address bar. See the <a href="https://www.facebook.com/business/help/1492627900875762">docs</a> for more information.|
|start_date|string||null|The date from which you'd like to replicate data for all incremental streams, in the format YYYY-MM-DDT00:00:00Z. All data generated after this date will be replicated.|
|end_date|string||null|The date until which you'd like to replicate data for all incremental streams, in the format YYYY-MM-DDT00:00:00Z. All data generated between the start date and this end date will be replicated. Not setting this option will result in always syncing the latest data.|
|access_token|string||null|The value of the generated access token. From your App’s Dashboard, click on "Marketing API" then "Tools". Select permissions <b>ads_management, ads_read, read_insights, business_management</b>. Then click on "Get token". See the <a href="https://docs.airbyte.com/integrations/sources/facebook-marketing">docs</a> for more information.|
|include_deleted|boolean||false|Set to active if you want to include data from deleted Campaigns, Ads, and AdSets.|
|fetch_thumbnail_images|boolean||false|Set to active if you want to fetch the thumbnail_url and store the result in thumbnail_data_url for each Ad Creative.|
|custom_insights|array||null|A list which contains ad statistics entries, each entry must have a name and can contains fields, breakdowns or action_breakdowns. Click on "add" to fill this field.|
|page_size|integer||100|Page size used when sending requests to Facebook API to specify number of records per page when response has pagination. Most users do not need to set this field unless they specifically need to tune the connector to address specific issues or use cases.|
|insights_lookback_window|integer||28|The attribution window. Facebook freezes insight data 28 days after it was generated, which means that all data from the past 28 days may have changed since we last emitted it, so you can retrieve refreshed insights from the past by setting this parameter. If you set a custom lookback window value in Facebook account, please provide the same value here.|
|max_batch_size|integer||50|Maximum batch size used when sending batch requests to Facebook API. Most users do not need to set this field unless they specifically need to tune the connector to address specific issues or use cases.|
|action_breakdowns_allow_empty|boolean||true|Allows action_breakdowns to be an empty list|
|custom_insights.items.name|string||null|The name value of insight|
|custom_insights.items.level|string||ad|Chosen level for API|
|custom_insights.items.fields|array||[]|A list of chosen fields for fields parameter|
|custom_insights.items.breakdowns|array||[]|A list of chosen breakdowns for breakdowns|
|custom_insights.items.action_breakdowns|array||[]|A list of chosen action_breakdowns for action_breakdowns|
|custom_insights.items.time_increment|integer||1|Time window in days by which to aggregate statistics. The sync will be chunked into N day intervals, where N is the number of days you specified. For example, if you set this value to 7, then all statistics will be reported as 7-day aggregates by starting from the start_date. If the start and end dates are October 1st and October 30th, then the connector will output 5 records: 01 - 06, 07 - 13, 14 - 20, 21 - 27, and 28 - 30 (3 days only).|
|custom_insights.items.start_date|string||null|The date from which you'd like to replicate data for this stream, in the format YYYY-MM-DDT00:00:00Z.|
|custom_insights.items.end_date|string||null|The date until which you'd like to replicate data for this stream, in the format YYYY-MM-DDT00:00:00Z. All data generated between the start date and this end date will be replicated. Not setting this option will result in always syncing the latest data.|
|custom_insights.items.insights_lookback_window|integer||28|The attribution window|

# Facebook Marketing Source 

This is the repository for the Facebook Marketing source connector, written in Python. 
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/facebook-marketing).

## Local development

### Prerequisites
**To iterate on this connector, make sure to complete this prerequisites section.**

#### Minimum Python version required `= 3.9.0`

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
./gradlew :airbyte-integrations:connectors:source-facebook-marketing:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/facebook-marketing)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_facebook_marketing/spec.json` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source facebook-marketing test creds`
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
docker build . -t airbyte/source-facebook-marketing:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-facebook-marketing:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-facebook-marketing:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-facebook-marketing:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-facebook-marketing:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-facebook-marketing:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
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
docker build . --no-cache -t airbyte/source-facebook-marketing:dev \
&& python -m pytest -p connector_acceptance_test.plugin
```
To run your integration tests with docker

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unittest run:
```
./gradlew :airbyte-integrations:connectors:source-facebook-marketing:unitTest
```
To run acceptance and custom integration tests run:
```
./gradlew :airbyte-integrations:connectors:source-facebook-marketing:IntegrationTest
```

## Dependency Management
All of your dependencies should go in `setup.py`, NOT `requirements.txt`. The requirements file is only used to connect internal Airbyte dependencies in the monorepo for local development.
We split dependencies between two groups, dependencies that are:
* required for your connector to work need to go to `MAIN_REQUIREMENTS` list.
* required for the testing need to go to `TEST_REQUIREMENTS` list

### Publishing a new version of the connector
You've checked out the repo, implemented a million dollar feature, and you're ready to share your changes with the world. Now what?
1. Make sure your changes are passing unit and integration tests
1. Bump the connector version in `Dockerfile` -- just increment the value of the `LABEL io.airbyte.version` appropriately (we use [SemVer](https://semver.org/)).
1. Create a Pull Request
1. Pat yourself on the back for being an awesome contributor
1. Someone from Airbyte will take a look at your PR and iterate with you to merge it into master
