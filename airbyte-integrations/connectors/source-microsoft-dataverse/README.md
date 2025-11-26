# Microsoft Dataverse / Dynamics 365 Source

## Overview

This connector syncs data from **Microsoft Dataverse** and **Microsoft Dynamics 365** applications.

### What's the relationship between Dataverse and Dynamics 365?

**Microsoft Dataverse** is the underlying data platform that powers **Dynamics 365** applications (Sales, Customer Service, Field Service, Marketing, Project Operations, etc.). They use the **same Web API**, which means:

- This single connector works for both Dataverse and Dynamics 365
- All Dynamics 365 applications are built on top of Dataverse
- The API endpoint, authentication, and data access patterns are identical

Whether you're using standalone Dataverse or any Dynamics 365 application, you can use this connector to sync your data.

## Example
```json
{
  "url": "https://example.crm.dynamics.com",
  "tenant_id": "example_tenant_id",
  "client_id": "example_client_id",
  "client_secret_value": "example_client_secret",
  "odata_maxpagesize": 10000
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|url |string||null|URL to your Dataverse / Dynamics 365 instance (e.g., https://yourorg.crm.dynamics.com)|
|tenant_id |string||null|Azure AD Tenant ID for your organization|
|client_id |string||null|Azure AD App Registration Client ID|
|client_secret_value |string||null|Azure AD App Registration Client Secret|
|odata_maxpagesize |integer||5000|Max number of results per page (Default: 5000, Max: 5000)|

## Supported Features

- **Full Refresh Sync** - Retrieve all records from entities
- **Incremental Sync** - Retrieve only new and updated records (for entities with change tracking enabled)
- **Change Data Capture (CDC)** - Track deleted records
- **Dynamic Schema Discovery** - Automatically discovers all standard and custom entities
- **Pagination** - Handles large datasets efficiently

## Supported Entities

This connector automatically discovers and syncs:
- All standard Dynamics 365 entities (Accounts, Contacts, Opportunities, Cases, etc.)
- All custom entities in your environment
- System entities (where permissions allow)

The actual entities available depend on your Dynamics 365 applications and customizations.

## Authentication Setup

This connector uses OAuth 2.0 client credentials flow via Azure Active Directory.

### Prerequisites

1. **Azure AD App Registration**
   - Navigate to [Azure Portal](https://portal.azure.com) > Azure Active Directory > App registrations
   - Click "New registration"
   - Provide a name (e.g., "Airbyte Dataverse Connector")
   - Click "Register"
   - Note the **Application (client) ID** and **Directory (tenant) ID**

2. **Create Client Secret**
   - In your app registration, go to "Certificates & secrets"
   - Click "New client secret"
   - Add a description and choose expiration period
   - Click "Add"
   - **Copy the secret value immediately** (you won't be able to see it again)

3. **Grant API Permissions**
   - In your app registration, go to "API permissions"
   - Click "Add a permission" > "Dynamics CRM"
   - Select "Delegated permissions" or "Application permissions"
   - Add "user_impersonation" permission
   - Click "Grant admin consent"

4. **Assign Security Role in Dynamics 365**
   - Navigate to your Dynamics 365 instance
   - Go to Settings > Security > Application Users
   - Create a new application user linked to your Azure AD app
   - Assign appropriate security roles (e.g., System Administrator, System Customizer, or custom role)

### Finding Your Instance URL

Your Dataverse / Dynamics 365 URL follows this pattern:
- `https://<org-name>.crm.dynamics.com` (North America)
- `https://<org-name>.crm4.dynamics.com` (Europe)
- `https://<org-name>.crm5.dynamics.com` (APAC)
- Other regions have different numbers

You can find it by:
1. Logging into your Dynamics 365 application
2. Looking at the URL in your browser
3. Or in Power Platform Admin Center under "Environments"

---

# Developer Documentation

This is the repository for the Microsoft Dataverse / Dynamics 365 source connector, written in Python.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/microsoft-dataverse).

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
./gradlew :airbyte-integrations:connectors:source-microsoft-dataverse:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/microsoft-dataverse)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_microsoft_dataverse/spec.yaml` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source microsoft-dataverse test creds`
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
docker build . -t airbyte/source-microsoft-dataverse:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-microsoft-dataverse:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-microsoft-dataverse:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-microsoft-dataverse:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-microsoft-dataverse:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-microsoft-dataverse:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```
## Testing
Make sure to familiarize yourself with [pytest test discovery](https://docs.pytest.org/en/latest/goodpractices.html#test-discovery) to know how your test files and methods should be named.
First install test dependencies into your virtual environment:
```
pip install .[tests]
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
./gradlew :airbyte-integrations:connectors:source-microsoft-dataverse:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-microsoft-dataverse:integrationTest
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
