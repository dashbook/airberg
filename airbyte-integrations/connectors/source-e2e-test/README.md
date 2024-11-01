# Source e2e-test

## Example
```
{
  "type": "BENCHMARK",
  "schema": "FIVE_STRING_COLUMNS",
  "terminationCondition": {
    "type": "MAX_RECORDS",
    "max": 1000
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|0.type|string|INFINITE_FEED|INFINITE_FEED||
|0.max_records|integer||null|Number of records to emit. If not set, defaults to infinity.|
|0.message_interval|integer||null|Interval between messages in ms.|
|1.type|string|EXCEPTION_AFTER_N|EXCEPTION_AFTER_N||
|1.throw_after_n_records|integer||null|Number of records to emit before throwing an exception. Min 1.|
|2.type|string|CONTINUOUS_FEED|CONTINUOUS_FEED||
|2.max_messages|integer||100|Number of records to emit per stream. Min 1. Max 100 billion.|
|2.seed|integer||0|When the seed is unspecified, the current time millis will be used as the seed. Range: [0, 1000000].|
|2.message_interval_ms|integer||0|Interval between messages in ms. Min 0 ms. Max 60000 ms (1 minute).|
|2.mock_catalog|object||null||
|2.mock_catalog.0.type|string|SINGLE_STREAM|SINGLE_STREAM||
|2.mock_catalog.0.stream_name|string||data_stream|Name of the data stream.|
|2.mock_catalog.0.stream_schema|string||{ "type": "object", "properties": { "column1": { "type": "string" } } }|A Json schema for the stream. The schema should be compatible with <a href="https://json-schema.org/draft-07/json-schema-release-notes.html">draft-07</a>. See <a href="https://cswr.github.io/JsonSchema/spec/introduction/">this doc</a> for examples.|
|2.mock_catalog.0.stream_duplication|integer||1|Duplicate the stream for easy load testing. Each stream name will have a number suffix. For example, if the stream name is "ds", the duplicated streams will be "ds_0", "ds_1", etc.|
|2.mock_catalog.1.type|string|MULTI_STREAM|MULTI_STREAM||
|2.mock_catalog.1.stream_schemas|string||{ "stream1": { "type": "object", "properties": { "field1": { "type": "string" } } }, "stream2": { "type": "object", "properties": { "field1": { "type": "boolean" } } } }|A Json object specifying multiple data streams and their schemas. Each key in this object is one stream name. Each value is the schema for that stream. The schema should be compatible with <a href="https://json-schema.org/draft-07/json-schema-release-notes.html">draft-07</a>. See <a href="https://cswr.github.io/JsonSchema/spec/introduction/">this doc</a> for examples.|
|3.type|string|BENCHMARK|BENCHMARK||
|3.schema|string||null|schema of the data in the benchmark.|
|3.terminationCondition|object||null|when does the benchmark stop?|
|3.terminationCondition.0.type|string|MAX_RECORDS|MAX_RECORDS||
|3.terminationCondition.0.max|number||null||

# End-to-End Testing Source

This is the repository for the mock source connector in Java. For information about how to use this connector within Airbyte, see [the User Documentation](https://docs.airbyte.io/integrations/sources/e2e-test)

## Mock Json record generation
The [airbytehq/jsongenerator](https://github.com/airbytehq/jsongenerator) is used to generate random Json records based on the specified Json schema. This library is forked from [jimblackler/jsongenerator](https://github.com/jimblackler/jsongenerator) authored by [Jim Blackler](https://github.com/jimblackler) and licensed under Apache 2.0.

Although this library seems to be the best one available for Json generation in Java, it has two downsides.
  - It relies on JavaScript inside Java (through `org.mozilla:rhino-engine`), and fetches remote JavaScript snippets (in the [PatternReverser](https://github.com/jimblackler/jsongenerator/blob/master/src/main/java/net/jimblackler/jsongenerator/PatternReverser.java)).
  - It does not allow customization of individual field. The generated Json object can be seemingly garbled. We may use libraries such as [java-faker](https://github.com/DiUS/java-faker) in the future to argument it.

## Local development

#### Building via Gradle
From the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-e2e-test:build
```

#### Create credentials
No credential is needed for this connector. 

### Locally running the connector docker image

#### Build
Build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-e2e-test:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-e2e-test:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-e2e-test:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-e2e-test:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-e2e-test:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```

#### Cloud variant
The cloud version of this connector only allows the `CONTINUOUS FEED` mode. When this mode is changed, please make sure that the cloud variant is updated and published accordingly as well.

## Testing
We use `JUnit` for Java tests.

### Unit and Integration Tests
Place unit tests under `src/test/io/airbyte/integrations/sources/e2e-test`.

#### Acceptance Tests
Airbyte has a standard test suite that all destination connectors must pass. See example(s) in
`src/test-integration/java/io/airbyte/integrations/sources/e2e-test/`.

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:sources-e2e-test:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:sources-e2e-test:integrationTest
```

## Dependency Management

### Publishing a new version of the connector
You've checked out the repo, implemented a million dollar feature, and you're ready to share your changes with the world. Now what?
1. Make sure your changes are passing unit and integration tests.
2. Bump the connector version in `Dockerfile` -- just increment the value of the `LABEL io.airbyte.version` appropriately (we use [SemVer](https://semver.org/)).
3. Create a Pull Request.
4. Pat yourself on the back for being an awesome contributor.
5. Someone from Airbyte will take a look at your PR and iterate with you to merge it into master.
