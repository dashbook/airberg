# Source jira

## Example
```json
{
  "api_token": "your_api_token",
  "domain": "your_domain.atlassian.net",
  "email": "your_email@example.com",
  "projects": ["PROJ1", "PROJ2"],
  "start_date": "2021-03-01T00:00:00Z",
  "expand_issue_changelog": true,
  "render_fields": true,
  "enable_experimental_streams": true
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|api_token |string||null|Jira API Token. See the <a href="https://docs.airbyte.com/integrations/sources/jira">docs</a> for more information on how to generate this key. API Token is used for Authorization to your account by BasicAuth.|
|domain |string||null|The Domain for your Jira account, e.g. airbyteio.atlassian.net, airbyteio.jira.com, jira.your-domain.com|
|email |string||null|The user email for your Jira account which you used to generate the API token. This field is used for Authorization to your account by BasicAuth.|
|projects |array||null|List of Jira project keys to replicate data for, or leave it empty if you want to replicate data for all projects.|
|start_date |string||null|The date from which you want to replicate data from Jira, use the format YYYY-MM-DDT00:00:00Z. Note that this field only applies to certain streams, and only data generated on or after the start date will be replicated. Or leave it empty if you want to replicate all data. For more information, refer to the <a href="https://docs.airbyte.com/integrations/sources/jira/">documentation</a>.|
|expand_issue_changelog |boolean||false|Expand the changelog when replicating issues.|
|render_fields |boolean||false|Render issue fields in HTML format in addition to Jira JSON-like format.|
|enable_experimental_streams |boolean||false|Allow the use of experimental streams which rely on undocumented Jira API endpoints. See https://docs.airbyte.com/integrations/sources/jira#experimental-tables for more info.|

# Jira Source 

This is the repository for the Jira source connector, written in Python. 
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/jira).

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
./gradlew :airbyte-integrations:connectors:source-jira:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/jira)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_jira/spec.json` file.
Note that the `secrets` directory is gitignored by default, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source jira test creds`
and place them into `secrets/config.json`.


### Locally running the connector
```
python main.py spec
python main.py check --config secrets/config.json
python main.py discover --config secrets/config.json
python main.py read --config secrets/config.json --catalog integration_tests/configured_catalog.json
```

### Unit Tests
To run unit tests locally, from the connector directory run:
```
python -m pytest unit_tests
```

### Locally running the connector docker image

#### Build
First, make sure you build the latest Docker image:
```
docker build . -t airbyte/source-jira:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-jira:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-jira:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-jira:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-jira:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-jira:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```

#### Acceptance Tests
Customize `acceptance-test-config.yml` file to configure tests. See [Connector Acceptance Tests](https://docs.airbyte.io/connector-development/testing-connectors/connector-acceptance-tests-reference) for more information.
If your connector requires to create or destroy resources for use during acceptance tests create fixtures for it and place them inside integration_tests/acceptance.py.
To run your integration tests with acceptance tests, from the connector root, run
```
docker build . --no-cache -t airbyte/source-jira:dev \
&& python -m pytest -p connector_acceptance_test.plugin
```

### Integration Tests
1. From the airbyte project root, run `./gradlew :airbyte-integrations:connectors:source-jira:integrationTest` to run the standard integration test suite.
1. To run additional integration tests, place your integration tests in a new directory `integration_tests` and run them with `python -m pytest -s integration_tests`.
   Make sure to familiarize yourself with [pytest test discovery](https://docs.pytest.org/en/latest/goodpractices.html#test-discovery) to know how your test files and methods should be named.

## Dependency Management
All of your dependencies should go in `setup.py`, NOT `requirements.txt`. The requirements file is only used to connect internal Airbyte dependencies in the monorepo for local development.

### Publishing a new version of the connector
You've checked out the repo, implemented a million dollar feature, and you're ready to share your changes with the world. Now what?
1. Make sure your changes are passing unit and integration tests
1. Bump the connector version in `Dockerfile` -- just increment the value of the `LABEL io.airbyte.version` appropriately (we use SemVer).
1. Create a Pull Request
1. Pat yourself on the back for being an awesome contributor
1. Someone from Airbyte will take a look at your PR and iterate with you to merge it into master
