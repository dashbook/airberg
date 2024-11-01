# Source sftp

## Example
```json
{
  "user": "username",
  "host": "www.host.com",
  "port": 22,
  "credentials": {
    "auth_method": "SSH_PASSWORD_AUTH",
    "auth_user_password": "password"
  },
  "file_types": "csv,json",
  "folder_path": "/logs/2022",
  "file_pattern": "log-([0-9]{4})([0-9]{2})([0-9]{2})"
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|user|string||null|The server user|
|host|string||null|The server host address|
|port|integer||22|The server port|
|credentials|object||null|The server authentication method|
|file_types|string||csv,json|Coma separated file types. Currently only 'csv' and 'json' types are supported.|
|folder_path|string|||The directory to search files for sync|
|file_pattern|string|||The regular expression to specify files for sync in a chosen Folder Path|
|credentials.0.auth_method|string|SSH_PASSWORD_AUTH|null|Connect through password authentication|
|credentials.0.auth_user_password|string||null|OS-level password for logging into the jump server host|
|credentials.1.auth_method|string|SSH_KEY_AUTH|null|Connect through ssh key|
|credentials.1.auth_ssh_key|string||null|OS-level user account ssh key credentials in RSA PEM format ( created with ssh-keygen -t rsa -m PEM -f myuser_rsa )|

# Source Sftp

This is the repository for the Sftp source connector in Java.
For information about how to use this connector within Airbyte, see [the User Documentation](https://docs.airbyte.com/integrations/sources/sftp/).

## Local development

#### Building via Gradle
From the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-sftp:build
```

#### Create credentials
**If you are a community contributor**, generate the necessary credentials and place them in `secrets/config.json` conforming to the spec file in `src/main/resources/spec.json`.
Note that the `secrets` directory is git-ignored by default, so there is no danger of accidentally checking in sensitive information.

**If you are an Airbyte core member**, follow the [instructions](https://docs.airbyte.io/connector-development#using-credentials-in-ci) to set up the credentials.

### Locally running the connector docker image

#### Build
Build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-sftp:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-sftp:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-sftp:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-sftp:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-sftp:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```

## Testing
We use `JUnit` for Java tests.

### Unit and Integration Tests
Place unit tests under `src/test/io/airbyte/integrations/source/sftp`.

#### Acceptance Tests
Airbyte has a standard test suite that all source connectors must pass. Implement the `TODO`s in
`src/test-integration/java/io/airbyte/integrations/source/sftpSourceAcceptanceTest.java`.

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:source-sftp:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-sftp:integrationTest
```

## Dependency Management

### Publishing a new version of the connector
You've checked out the repo, implemented a million dollar feature, and you're ready to share your changes with the world. Now what?
1. Make sure your changes are passing unit and integration tests.
1. Bump the connector version in `Dockerfile` -- just increment the value of the `LABEL io.airbyte.version` appropriately (we use [SemVer](https://semver.org/)).
1. Create a Pull Request.
1. Pat yourself on the back for being an awesome contributor.
1. Someone from Airbyte will take a look at your PR and iterate with you to merge it into master.
