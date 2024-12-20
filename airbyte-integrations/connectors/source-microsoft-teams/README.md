# Source microsoft-teams

## Example
```json
{
  "period": "D7",
  "credentials": {
    "auth_type": "Client",
    "tenant_id": "your_tenant_id",
    "client_id": "your_client_id",
    "client_secret": "your_client_secret",
    "refresh_token": "your_refresh_token"
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|period |string||null|Specifies the length of time over which the Team Device Report stream is aggregated. The supported values are: D7, D30, D90, and D180.|
|credentials.auth_type 0|string|Client|Client||
|credentials.tenant_id 0|string||null|A globally unique identifier (GUID) that is different than your organization name or domain. Follow these steps to obtain: open one of the Teams where you belong inside the Teams Application -> Click on the … next to the Team title -> Click on Get link to team -> Copy the link to the team and grab the tenant ID form the URL|
|credentials.client_id 0|string||null|The Client ID of your Microsoft Teams developer application.|
|credentials.client_secret 0|string||null|The Client Secret of your Microsoft Teams developer application.|
|credentials.refresh_token 0|string||null|A Refresh Token to renew the expired Access Token.|
|credentials.auth_type 1|string|Token|Token||
|credentials.tenant_id 1|string||null|A globally unique identifier (GUID) that is different than your organization name or domain. Follow these steps to obtain: open one of the Teams where you belong inside the Teams Application -> Click on the … next to the Team title -> Click on Get link to team -> Copy the link to the team and grab the tenant ID form the URL|
|credentials.client_id 1|string||null|The Client ID of your Microsoft Teams developer application.|
|credentials.client_secret 1|string||null|The Client Secret of your Microsoft Teams developer application.|

# Microsoft Teams Source 

This is the repository for the Microsoft Teams source connector, written in Python. 
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/microsoft-teams).

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
./gradlew :airbyte-integrations:connectors:source-microsoft-teams:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/microsoft-teams)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_microsoft_teams/spec.json` file.
Note that the `secrets` directory is gitignored by default, so there is no danger of accidentally checking in sensitive information.
See `sample_files/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source microsoft-teams test creds`
and place them into `secrets/config.json`.


### Locally running the connector
```
python main_dev.py spec
python main_dev.py check --config secrets/config.json
python main_dev.py discover --config secrets/config.json
python main_dev.py read --config secrets/config.json --catalog sample_files/configured_catalog.json
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
docker build . -t airbyte/source-microsoft-teams:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-microsoft-teams:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-microsoft-teams:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-microsoft-teams:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-microsoft-teams:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/sample_files:/sample_files airbyte/source-microsoft-teams:dev read --config /secrets/config.json --catalog /sample_files/configured_catalog.json
```

### Integration Tests
1. From the airbyte project root, run `./gradlew :airbyte-integrations:connectors:source-microsoft-teams:integrationTest` to run the standard integration test suite.
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
