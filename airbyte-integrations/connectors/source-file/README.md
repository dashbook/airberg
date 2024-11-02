# Source file

## Example
```json
{
  "dataset_name": "example_dataset",
  "format": "csv",
  "reader_options": "{\"sep\": \"\t\"}",
  "url": "https://example.com/data.csv",
  "provider": {
    "storage": "HTTPS",
    "user_agent": true
  }
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
|provider.storage 7|string|local|null|WARNING: Note that the local storage URL available for reading must start with the local mount "/local/" at the moment until we implement more advanced docker mounting options.|

# File Source 

This is the repository for the File source connector, written in Python. 
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/file).

## Local development

### Prerequisites
**To iterate on this connector, make sure to complete this prerequisites section.**

#### Connector-Specific Dependencies

For this connector, you will need Rust, as it is a prerequisite for running `pip install cryptography`. You can do this with the recommended installation pattern noted [here](https://www.rust-lang.org/tools/install) on the Rust website.

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
./gradlew :airbyte-integrations:connectors:source-file:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/file)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_file/spec.json` file.
Note that the `secrets` directory is gitignored by default, so there is no danger of accidentally checking in sensitive information.
See `sample_files/sample_config.json` for a sample config file.

#### Necessary Credentials for tests

In order to run integrations tests in this connector, you need:
1. Testing Google Cloud Service Storage
   1. Download and store your Google [Service Account](https://console.cloud.google.com/iam-admin/serviceaccounts) JSON file in `secrets/gcs.json`, it should look something like this:   
        ```
        {
            "type": "service_account",
            "project_id": "XXXXXXX",
            "private_key_id": "XXXXXXXX",
            "private_key": "-----BEGIN PRIVATE KEY-----\nXXXXXXXXXX\n-----END PRIVATE KEY-----\n",
            "client_email": "XXXXX@XXXXXX.iam.gserviceaccount.com",
            "client_id": "XXXXXXXXX",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/XXXXXXX0XXXXXX.iam.gserviceaccount.com"
        }
        ```
   2. Your Service Account should have [Storage Admin Rights](https://console.cloud.google.com/iam-admin/iam) (to create Buckets, read and store files in GCS)

2. Testing Amazon S3 
    1. Create a file at `secrets/aws.json`   
       ```
        {
            "aws_access_key_id": "XXXXXXX",
            "aws_secret_access_key": "XXXXXXX"
        }
       ```

3. Testing Azure Blob Storage
   1. Create a file at `secrets/azblob.json`
        ```
        {
            "storage_account": "XXXXXXX",
            "shared_key": "XXXXXXX",
            "sas_token": "XXXXXXX"
        }
       ```

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
docker build . -t airbyte/source-file:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-file:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-file:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-file:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-file:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/sample_files:/sample_files airbyte/source-file:dev read --config /secrets/config.json --catalog /sample_files/configured_catalog.json
```

### Integration Tests
1. From the airbyte project root, run `./gradlew :airbyte-integrations:connectors:source-file:integrationTest` to run the standard integration test suite.
2. To run additional integration tests, place your integration tests in a new directory `integration_tests` and run them with `python -m pytest -s integration_tests`.
   Make sure to familiarize yourself with [pytest test discovery](https://docs.pytest.org/en/latest/goodpractices.html#test-discovery) to know how your test files and methods should be named.

#### Acceptance Tests
Customize `acceptance-test-config.yml` file to configure tests. See [Connector Acceptance Tests](https://docs.airbyte.io/connector-development/testing-connectors/connector-acceptance-tests-reference) for more information.
If your connector requires to create or destroy resources for use during acceptance tests create fixtures for it and place them inside integration_tests/acceptance.py.
To run your integration tests with acceptance tests, from the connector root, run
```
docker build . --no-cache -t airbyte/source-file:dev \
&& python -m pytest -p connector_acceptance_test.plugin
```
To run your integration tests with docker

## Dependency Management
All of your dependencies should go in `setup.py`, NOT `requirements.txt`. The requirements file is only used to connect internal Airbyte dependencies in the monorepo for local development.

### Publishing a new version of the connector
You've checked out the repo, implemented a million dollar feature, and you're ready to share your changes with the world. Now what?
1. Make sure your changes are passing unit and integration tests
2. Bump the connector version in `Dockerfile` -- just increment the value of the `LABEL io.airbyte.version` appropriately (we use SemVer).
3. In addition to bumping the connector version of `source-file`, you must also increment the version of `source-file-secure` which depends on this source. The versions of these connectors should always remain in sync. Depending on the changes to `source-file`, you may also need to make changes to `source-file-secure` to retain compatibility.
4. Create a Pull Request
5. Pat yourself on the back for being an awesome contributor
6. Someone from Airbyte will take a look at your PR and iterate with you to merge it into master
