# Source file-secure

## Example
```json
{
  "dataset_name": "my_dataset",
  "format": "csv",
  "url": "https://storage.googleapis.com/covid19-open-data/v2/latest/epidemiology.csv",
  "provider": {
    "storage": "HTTPS",
    "user_agent": true
  },
  "reader_options": "{\"sep\": \" \"}"
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|dataset_name |string||null|The Name of the final table to replicate this file into (should include letters, numbers dash and underscores only).|
|format |string||csv|The Format of the file which should be replicated (Warning: some formats may be experimental, please refer to the docs).|
|reader_options |string||null|This should be a string in JSON format. It depends on the chosen file format to provide additional options and tune its behavior.|
|url |string||null|The URL path to access the file which should be replicated.|
|provider |||null||
|provider |||null||
|provider |||null||
|provider |||null||
|provider |||null||
|provider |||null||
|provider |||null||
|provider.storage 0|string|HTTPS|null||
|provider.user_agent 0|boolean||false|Add User-Agent to request|
|provider.storage 1|string|GCS|null||
|provider.service_account_json 1|string||null|In order to access private Buckets stored on Google Cloud, this connector would need a service account json credentials with the proper permissions as described <a href="https://cloud.google.com/iam/docs/service-accounts" target="_blank">here</a>. Please generate the credentials.json file and copy/paste its content to this field (expecting JSON formats). If accessing publicly available data, this field is not necessary.|
|provider.storage 2|string|S3|null||
|provider.aws_access_key_id 2|string||null|In order to access private Buckets stored on AWS S3, this connector would need credentials with the proper permissions. If accessing publicly available data, this field is not necessary.|
|provider.aws_secret_access_key 2|string||null|In order to access private Buckets stored on AWS S3, this connector would need credentials with the proper permissions. If accessing publicly available data, this field is not necessary.|
|provider.storage 3|string|AzBlob|null||
|provider.storage_account 3|string||null|The globally unique name of the storage account that the desired blob sits within. See <a href="https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview" target="_blank">here</a> for more details.|
|provider.sas_token 3|string||null|To access Azure Blob Storage, this connector would need credentials with the proper permissions. One option is a SAS (Shared Access Signature) token. If accessing publicly available data, this field is not necessary.|
|provider.shared_key 3|string||null|To access Azure Blob Storage, this connector would need credentials with the proper permissions. One option is a storage account shared key (aka account key or access key). If accessing publicly available data, this field is not necessary.|
|provider.storage 4|string|SSH|null||
|provider.user 4|string||null||
|provider.password 4|string||null||
|provider.host 4|string||null||
|provider.port 4|string||22||
|provider.storage 5|string|SCP|null||
|provider.user 5|string||null||
|provider.password 5|string||null||
|provider.host 5|string||null||
|provider.port 5|string||22||
|provider.storage 6|string|SFTP|null||
|provider.user 6|string||null||
|provider.password 6|string||null||
|provider.host 6|string||null||
|provider.port 6|string||22||

# File Source Secure
This is the repository for the File source connector, written in Python. 
This is modificaion of another connector Source File. This version has only one difference with the origin version is this one doesn't support local file storages and is orientated for cloud and cluster platforms.
More details about dependencies and requirement are available [here](https://github.com/airbytehq/airbyte/blob/master/airbyte-integrations/connectors/source-file/README.md)

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
./gradlew :airbyte-integrations:connectors:source-file-secure:build
```

#### Create credentials
Details are explained [here](https://github.com/airbytehq/airbyte/blob/master/airbyte-integrations/connectors/source-file/README.md#create-credentials)

Note that the `secrets` directory is gitignored by default, so there is no danger of accidentally checking in sensitive information.
See `sample_files/sample_config.json` for a sample config file.



**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source file test creds`
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

### Locally running the connector docker image

#### Build
First, make sure you build the latest Docker image:
```
docker build . -t airbyte/source-file-secure:dev \
&& python -m pytest -p connector_acceptance_test.plugin
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-file-secure:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-file-secure:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-file-secure:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-file-secure:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/sample_files:/sample_files airbyte/source-file-secure:dev read --config /secrets/config.json --catalog /sample_files/configured_catalog.json
```

### Integration Tests
1. From the airbyte project root, run `./gradlew :airbyte-integrations:connectors:source-file-secure:integrationTest` to run the standard integration test suite.
1. To run additional integration tests, place your integration tests in a new directory `integration_tests` and run them with `python -m pytest -s ../source-file/integration_tests`.
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
