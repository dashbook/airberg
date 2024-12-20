# Source github

## Example
```json
{
  "credentials": {
    "option_title": "OAuth Credentials",
    "access_token": "your_access_token_here"
  },
  "start_date": "2021-03-01T00:00:00Z",
  "repository": "airbytehq/airbyte",
  "branch": "airbytehq/airbyte/master",
  "requests_per_hour": 1000
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|start_date |string||null|The date from which you'd like to replicate data from GitHub in the format YYYY-MM-DDT00:00:00Z. For the streams which support this configuration, only data generated on or after the start date will be replicated. This field doesn't apply to all streams, see the <a href="https://docs.airbyte.com/integrations/sources/github">docs</a> for more info|
|repository |string||null|Space-delimited list of GitHub organizations/repositories, e.g. `airbytehq/airbyte` for single repository, `airbytehq/*` for get all repositories from organization and `airbytehq/airbyte airbytehq/another-repo` for multiple repositories.|
|branch |string||null|Space-delimited list of GitHub repository branches to pull commits for, e.g. `airbytehq/airbyte/master`. If no branches are specified for a repository, the default branch will be pulled.|
|requests_per_hour |integer||null|The GitHub API allows for a maximum of 5000 requests per hour (15000 for Github Enterprise). You can specify a lower value to limit your use of the API quota.|
|credentials.option_title 0|string|OAuth Credentials|null||
|credentials.access_token 0|string||null|OAuth access token|
|credentials.option_title 1|string|PAT Credentials|null||
|credentials.personal_access_token 1|string||null|Log into GitHub and then generate a <a href="https://github.com/settings/tokens">personal access token</a>. To load balance your API quota consumption across multiple API tokens, input multiple tokens separated with ","|

# Github Source

This is the repository for the Github source connector, written in Python.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/github).

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
pip install '.[tests]'
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
./gradlew :airbyte-integrations:connectors:source-github:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/github)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_github/spec.json` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source github test creds`
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
docker build . -t airbyte/source-github:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-github:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-github:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-github:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-github:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-github:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
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
./gradlew :airbyte-integrations:connectors:source-github:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-github:integrationTest
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
