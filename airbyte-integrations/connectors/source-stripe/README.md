# Source stripe

## Example
```
{
  "client_secret": "sk_live_123456789",
  "account_id": "acct_123456789",
  "start_date": "2017-01-25T00:00:00Z",
  "lookback_window_days": 0,
  "slice_range": 30
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|account_id|string||null|Your Stripe account ID (starts with 'acct_', find yours <a href="https://dashboard.stripe.com/settings/account">here</a>).|
|client_secret|string||null|Stripe API key (usually starts with 'sk_live_'; find yours <a href="https://dashboard.stripe.com/apikeys">here</a>).|
|start_date|string||null|UTC date and time in the format 2017-01-25T00:00:00Z. Only data generated after this date will be replicated.|
|lookback_window_days|integer||0|When set, the connector will always re-export data from the past N days, where N is the value set here. This is useful if your data is frequently updated after creation. More info <a href="https://docs.airbyte.com/integrations/sources/stripe#requirements">here</a>|
|slice_range|integer||365|The time increment used by the connector when requesting data from the Stripe API. The bigger the value is, the less requests will be made and faster the sync will be. On the other hand, the more seldom the state is persisted.|

# Stripe Source

This is the repository for the Stripe source connector, written in Python.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/stripe).

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
You can also build the connector in Gradle. This is typically used in CI and not needed for your development workflow.

To build using Gradle, from the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-stripe:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/stripe)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_stripe/spec.yaml` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `sample_files/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source stripe test creds`
and place them into `secrets/config.json`.


### Locally running the connector
```
python main.py spec
python main.py check --config secrets/config.json
python main.py discover --config secrets/config.json
python main.py read --config secrets/config.json --catalog sample_files/configured_catalog.json
```

### Unit Tests
To run unit tests locally, from the connector directory run:
```
python -m pytest unit_tests
```

#### Acceptance Tests
Customize `acceptance-test-config.yml` file to configure tests. See [Connector Acceptance Tests](https://docs.airbyte.io/connector-development/testing-connectors/connector-acceptance-tests-reference) for more information.
If your connector requires to create or destroy resources for use during acceptance tests create fixtures for it and place them inside integration_tests/acceptance.py.
To run your integration tests with acceptance tests, from the connector root, run
```
docker build . --no-cache -t airbyte/source-stripe:dev \
&& python -m pytest integration_tests -p integration_tests.acceptance
```

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:source-stripe:unitTest
```

To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-stripe:integrationTest
```

#### Build
To run your integration tests with docker localy

First, make sure you build the latest Docker image:
```
docker build --no-cache . -t airbyte/source-stripe:dev
```

You can also build the connector image via Gradle:
```
./gradlew clean :airbyte-integrations:connectors:source-stripe:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-stripe:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-stripe:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-stripe:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/sample_files:/sample_files airbyte/source-stripe:dev read --config /secrets/config.json --catalog /sample_files/configured_catalog.json
```

### Integration Tests
1. From the airbyte project root, run `./gradlew :airbyte-integrations:connectors:source-stripe:integrationTest` to run the standard integration test suite.
1. To run additional integration tests, place your integration tests in a new directory `integration_tests` and run them with `python -m pytest -s integration_tests`.
   Make sure to familiarize yourself with [pytest test discovery](https://docs.pytest.org/en/latest/goodpractices.html#test-discovery) to know how your test files and methods should be named.

## Dependency Management
All of your dependencies should go in `setup.py`, NOT `requirements.txt`. The requirements file is only used to connect internal Airbyte dependencies in the monorepo for local development.

### Publishing a new version of the connector
You've checked out the repo, implemented a million dollar feature, and you're ready to share your changes with the world. Now what?
1. Make sure your changes are passing unit and integration tests
2. Bump the connector version in `Dockerfile` -- just increment the value of the `LABEL io.airbyte.version` appropriately (we use SemVer).
3. Create a Pull Request
4. Pat yourself on the back for being an awesome contributor
5. Someone from Airbyte will take a look at your PR and iterate with you to merge it into master


### additional connector/streams properties of note

Some stripe streams are mutable, meaning that after an incremental update, new data items could appear *before* 
the latest update date. To work around that, define the lookback_window_days to define a window in days to fetch results
before the latest state date, in order to capture "delayed" data items.
