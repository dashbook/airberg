# Source azure-blob-storage

## Example
```
{
  "azure_blob_storage_account_name": "airbyte5storage",
  "azure_blob_storage_account_key": "Z8ZkZpteggFx394vm+PJHnGTvdRncaYS+JhLKdj789YNmD+iyGTnG+PV+POiuYNhBg/ACS+LKjd%4FG3FHGN12Nd==",
  "azure_blob_storage_container_name": "airbytetescontainername",
  "format": {
    "format_type": "JSONL"
  },
  "azure_blob_storage_endpoint": "blob.core.windows.net",
  "azure_blob_storage_blobs_prefix": "FolderA/FolderB/",
  "azure_blob_storage_schema_inference_limit": 500
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|azure_blob_storage_endpoint |string||blob.core.windows.net|This is Azure Blob Storage endpoint domain name. Leave default value (or leave it empty if run container from command line) to use Microsoft native from example.|
|azure_blob_storage_container_name |string||null|The name of the Azure blob storage container.|
|azure_blob_storage_account_name |string||null|The account's name of the Azure Blob Storage.|
|azure_blob_storage_account_key |string||null|The Azure blob storage account key.|
|azure_blob_storage_blobs_prefix |string||null|The Azure blob storage prefix to be applied|
|azure_blob_storage_schema_inference_limit |integer||null|The Azure blob storage blobs to scan for inferring the schema, useful on large amounts of data with consistent structure|
|format |||null||
|format.format_type 0|string|JSONL|null||

# Source Azure Blob Storage

This is the repository for the Azure Blob Storage source connector in Java.
For information about how to use this connector within Airbyte, see [the User Documentation](https://docs.airbyte.io/integrations/sources/azure-blob-storage).

## Local development

#### Building via Gradle
From the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-azure-blob-storage:build
```

#### Create credentials
**If you are a community contributor**, generate the necessary credentials and place them in `secrets/config.json` conforming to the spec file in `src/main/resources/spec.json`.
Note that the `secrets` directory is git-ignored by default, so there is no danger of accidentally checking in sensitive information.

**If you are an Airbyte core member**, follow the [instructions](https://docs.airbyte.io/connector-development#using-credentials-in-ci) to set up the credentials.

### Locally running the connector docker image

#### Build
Build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-azure-blob-storage:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-azure-blob-storage:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-azure-blob-storage:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-azure-blob-storage:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-azure-blob-storage:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```

## Testing
We use `JUnit` for Java tests.

### Unit and Integration Tests
Place unit tests under `src/test/...`
Place integration tests in `src/test-integration/...`

#### Acceptance Tests
Airbyte has a standard test suite that all source connectors must pass. Implement the `TODO`s in
`src/test-integration/java/io/airbyte/integrations/sources/AzureBlobStorageSourceAcceptanceTest.java`.

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:source-azure-blob-storage:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-azure-blob-storage:integrationTest
```

## Dependency Management

### Publishing a new version of the connector
You've checked out the repo, implemented a million dollar feature, and you're ready to share your changes with the world. Now what?
1. Make sure your changes are passing unit and integration tests.
1. Bump the connector version in `Dockerfile` -- just increment the value of the `LABEL io.airbyte.version` appropriately (we use [SemVer](https://semver.org/)).
1. Create a Pull Request.
1. Pat yourself on the back for being an awesome contributor.
1. Someone from Airbyte will take a look at your PR and iterate with you to merge it into master.
