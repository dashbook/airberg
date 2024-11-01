# Source s3

## Example
```json
{
  "dataset": "test_dataset",
  "path_pattern": "**",
  "format": {
    "filetype": "csv",
    "delimiter": ",",
    "infer_datatypes": true,
    "quote_char": "\"",
    "escape_char": "",
    "encoding": "utf8",
    "double_quote": true,
    "newlines_in_values": false,
    "additional_reader_options": "{\"timestamp_parsers\": [\"%m/%d/%Y %H:%M\", \"%Y/%m/%d %H:%M\"], \"strings_can_be_null\": true, \"null_values\": [\"NA\", \"NULL\"]}",
    "advanced_options": "{\"column_names\": [\"column1\", \"column2\"]}",
    "block_size": 10000
  },
  "provider": {
    "bucket": "my_bucket",
    "aws_access_key_id": "my_access_key_id",
    "aws_secret_access_key": "my_secret_access_key",
    "path_prefix": "my_folder",
    "endpoint": "",
    "start_date": "2021-01-01T00:00:00Z"
  },
  "schema": "{}"
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|dataset|string||null|The name of the stream you would like this source to output. Can contain letters, numbers, or underscores.|
|path_pattern|string||null|A regular expression which tells the connector which files to replicate. All files which match this pattern will be replicated. Use | to separate multiple patterns. See <a href="https://facelessuser.github.io/wcmatch/glob/" target="_blank">this page</a> to understand pattern syntax (GLOBSTAR and SPLIT flags are enabled). Use pattern <strong>**</strong> to pick up all files.|
|format|object||csv|The format of the files you'd like to replicate|
|schema|string||{}|Optionally provide a schema to enforce, as a valid JSON string. Ensure this is a mapping of <strong>{ "column" : "type" }</strong>, where types are valid <a href="https://json-schema.org/understanding-json-schema/reference/type.html" target="_blank">JSON Schema datatypes</a>. Leave as {} to auto-infer the schema.|
|format.0.filetype|string|csv|null||
|format.0.delimiter|string||,|The character delimiting individual cells in the CSV data. This may only be a 1-character string. For tab-delimited data enter '\t'.|
|format.0.infer_datatypes|boolean||true|Configures whether a schema for the source should be inferred from the current data or not. If set to false and a custom schema is set, then the manually enforced schema is used. If a schema is not manually set, and this is set to false, then all fields will be read as strings|
|format.0.quote_char|string||"|The character used for quoting CSV values. To disallow quoting, make this field blank.|
|format.0.escape_char|string||null|The character used for escaping special characters. To disallow escaping, leave this field blank.|
|format.0.encoding|string||utf8|The character encoding of the CSV data. Leave blank to default to <strong>UTF8</strong>. See <a href="https://docs.python.org/3/library/codecs.html#standard-encodings" target="_blank">list of python encodings</a> for allowable options.|
|format.0.double_quote|boolean||true|Whether two quotes in a quoted CSV value denote a single quote in the data.|
|format.0.newlines_in_values|boolean||false|Whether newline characters are allowed in CSV values. Turning this on may affect performance. Leave blank to default to False.|
|format.0.additional_reader_options|string||null|Optionally add a valid JSON string here to provide additional options to the csv reader. Mappings must correspond to options <a href="https://arrow.apache.org/docs/python/generated/pyarrow.csv.ConvertOptions.html#pyarrow.csv.ConvertOptions" target="_blank">detailed here</a>. 'column_types' is used internally to handle schema so overriding that would likely cause problems.|
|format.0.advanced_options|string||null|Optionally add a valid JSON string here to provide additional <a href="https://arrow.apache.org/docs/python/generated/pyarrow.csv.ReadOptions.html#pyarrow.csv.ReadOptions" target="_blank">Pyarrow ReadOptions</a>. Specify 'column_names' here if your CSV doesn't have header, or if you want to use custom column names. 'block_size' and 'encoding' are already used above, specify them again here will override the values above.|
|format.0.block_size|integer||10000|The chunk size in bytes to process at a time in memory from each file. If your data is particularly wide and failing during schema detection, increasing this should solve it. Beware of raising this too high as you could hit OOM errors.|
|format.1.filetype|string|parquet|null||
|format.1.columns|array||null|If you only want to sync a subset of the columns from the file(s), add the columns you want here as a comma-delimited list. Leave it empty to sync all columns.|
|format.1.batch_size|integer||65536|Maximum number of records per batch read from the input files. Batches may be smaller if there aren’t enough rows in the file. This option can help avoid out-of-memory errors if your data is particularly wide.|
|format.1.buffer_size|integer||2|Perform read buffering when deserializing individual column chunks. By default every group column will be loaded fully to memory. This option can help avoid out-of-memory errors if your data is particularly wide.|
|format.2.filetype|string|avro|null||
|format.3.filetype|string|jsonl|null||
|format.3.newlines_in_values|boolean||false|Whether newline characters are allowed in JSON values. Turning this on may affect performance. Leave blank to default to False.|
|format.3.unexpected_field_behavior|||infer|How JSON fields outside of explicit_schema (if given) are treated. Check <a href="https://arrow.apache.org/docs/python/generated/pyarrow.json.ParseOptions.html" target="_blank">PyArrow documentation</a> for details|
|format.3.block_size|integer||0|The chunk size in bytes to process at a time in memory from each file. If your data is particularly wide and failing during schema detection, increasing this should solve it. Beware of raising this too high as you could hit OOM errors.|
|provider.bucket|string||null|Name of the S3 bucket where the file(s) exist.|
|provider.aws_access_key_id|string||null|In order to access private Buckets stored on AWS S3, this connector requires credentials with the proper permissions. If accessing publicly available data, this field is not necessary.|
|provider.aws_secret_access_key|string||null|In order to access private Buckets stored on AWS S3, this connector requires credentials with the proper permissions. If accessing publicly available data, this field is not necessary.|
|provider.path_prefix|string|||By providing a path-like prefix (e.g. myFolder/thisTable/) under which all the relevant files sit, we can optimize finding these in S3. This is optional but recommended if your bucket contains many folders/files which you don't need to replicate.|
|provider.endpoint|string|||Endpoint to an S3 compatible service. Leave empty to use AWS.|
|provider.start_date|string||null|UTC date and time in the format 2017-01-25T00:00:00Z. Any file modified before this date will not be replicated.|

# S3 Source

This is the repository for the S3 source connector, written in Python.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/s3).

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
./gradlew :airbyte-integrations:connectors:source-s3:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/s3)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_s3/spec.json` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source s3 test creds`
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
docker build . --no-cache -t airbyte/source-s3:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-s3:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-s3:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-s3:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-s3:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-s3:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```
## Testing
Make sure to familiarize yourself with [pytest test discovery](https://docs.pytest.org/en/latest/goodpractices.html#test-discovery) to know how your test files and methods should be named.
First install test dependencies into your virtual environment:
```
pip install '.[tests]'
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
docker build . --no-cache -t airbyte/source-s3:dev \
&& python -m pytest -p connector_acceptance_test.plugin
```
To run your integration tests with docker

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:source-s3:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-s3:integrationTest
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
