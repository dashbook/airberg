# Source kafka

## Example
```
{
  "MessageFormat": {
    "deserialization_type": "AVRO",
    "deserialization_strategy": "TopicNameStrategy",
    "schema_registry_url": "http://localhost:8081",
    "schema_registry_username": "username",
    "schema_registry_password": "password",
    "bootstrap_servers": "kafka-broker1:9092,kafka-broker2:9092",
    "subscription": {
      "subscription_type": "subscribe",
      "topic_pattern": "sample.topic"
    },
    "test_topic": "test.topic",
    "group_id": "group.id",
    "max_poll_records": 500,
    "polling_time": 100,
    "protocol": {
      "security_protocol": "SASL_SSL",
      "sasl_mechanism": "GSSAPI",
      "sasl_jaas_config": "username/password"
    },
    "client_id": "airbyte-consumer",
    "enable_auto_commit": true,
    "auto_commit_interval_ms": 5000,
    "client_dns_lookup": "use_all_dns_ips",
    "retry_backoff_ms": 100,
    "request_timeout_ms": 30000,
    "receive_buffer_bytes": 32768,
    "auto_offset_reset": "latest",
    "repeated_calls": 3,
    "max_records_process": 100000
  }
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|bootstrap_servers |string||null|A list of host/port pairs to use for establishing the initial connection to the Kafka cluster. The client will make use of all servers irrespective of which servers are specified here for bootstrapping&mdash;this list only impacts the initial hosts used to discover the full set of servers. This list should be in the form <code>host1:port1,host2:port2,...</code>. Since these servers are just used for the initial connection to discover the full cluster membership (which may change dynamically), this list need not contain the full set of servers (you may want more than one, though, in case a server is down).|
|test_topic |string||null|The Topic to test in case the Airbyte can consume messages.|
|group_id |string||null|The Group ID is how you distinguish different consumer groups.|
|max_poll_records |integer||500|The maximum number of records returned in a single call to poll(). Note, that max_poll_records does not impact the underlying fetching behavior. The consumer will cache the records from each fetch request and returns them incrementally from each poll.|
|polling_time |integer||100|Amount of time Kafka connector should try to poll for messages.|
|client_id |string||null|An ID string to pass to the server when making requests. The purpose of this is to be able to track the source of requests beyond just ip/port by allowing a logical application name to be included in server-side request logging.|
|enable_auto_commit |boolean||true|If true, the consumer's offset will be periodically committed in the background.|
|auto_commit_interval_ms |integer||5000|The frequency in milliseconds that the consumer offsets are auto-committed to Kafka if enable.auto.commit is set to true.|
|client_dns_lookup |string||use_all_dns_ips|Controls how the client uses DNS lookups. If set to use_all_dns_ips, connect to each returned IP address in sequence until a successful connection is established. After a disconnection, the next IP is used. Once all IPs have been used once, the client resolves the IP(s) from the hostname again. If set to resolve_canonical_bootstrap_servers_only, resolve each bootstrap address into a list of canonical names. After the bootstrap phase, this behaves the same as use_all_dns_ips. If set to default (deprecated), attempt to connect to the first IP address returned by the lookup, even if the lookup returns multiple IP addresses.|
|retry_backoff_ms |integer||100|The amount of time to wait before attempting to retry a failed request to a given topic partition. This avoids repeatedly sending requests in a tight loop under some failure scenarios.|
|request_timeout_ms |integer||30000|The configuration controls the maximum amount of time the client will wait for the response of a request. If the response is not received before the timeout elapses the client will resend the request if necessary or fail the request if retries are exhausted.|
|receive_buffer_bytes |integer||32768|The size of the TCP receive buffer (SO_RCVBUF) to use when reading data. If the value is -1, the OS default will be used.|
|auto_offset_reset |string||latest|What to do when there is no initial offset in Kafka or if the current offset does not exist any more on the server - earliest: automatically reset the offset to the earliest offset, latest: automatically reset the offset to the latest offset, none: throw exception to the consumer if no previous offset is found for the consumer's group, anything else: throw exception to the consumer.|
|repeated_calls |integer||3|The number of repeated calls to poll() if no messages were received.|
|max_records_process |integer||100000|The Maximum to be processed per execution|
|MessageFormat |||null||
|MessageFormat |||null||
|MessageFormat.deserialization_type 0|string|JSON|null||
|MessageFormat.deserialization_type 1||AVRO|null||
|MessageFormat.deserialization_strategy 1|string||TopicNameStrategy||
|MessageFormat.schema_registry_url 1|string||null||
|MessageFormat.schema_registry_username 1|string||||
|MessageFormat.schema_registry_password 1|string||||
|subscription |||null||
|subscription |||null||
|subscription.subscription_type 0|string|assign|null|Manually assign a list of partitions to this consumer. This interface does not allow for incremental assignment and will replace the previous assignment (if there is one).
If the given list of topic partitions is empty, it is treated the same as unsubscribe().|
|subscription.topic_partitions 0|string||null||
|subscription.subscription_type 1|string|subscribe|null|The Topic pattern from which the records will be read.|
|subscription.topic_pattern 1|string||null||
|protocol |||null||
|protocol |||null||
|protocol |||null||
|protocol.security_protocol 0|string|PLAINTEXT|null||
|protocol.security_protocol 1|string|SASL_PLAINTEXT|null||
|protocol.sasl_mechanism 1|string|PLAIN|null|The SASL mechanism used for client connections. This may be any mechanism for which a security provider is available.|
|protocol.sasl_jaas_config 1|string|||The JAAS login context parameters for SASL connections in the format used by JAAS configuration files.|
|protocol.security_protocol 2|string|SASL_SSL|null||
|protocol.sasl_mechanism 2|string||GSSAPI|The SASL mechanism used for client connections. This may be any mechanism for which a security provider is available.|
|protocol.sasl_jaas_config 2|string|||The JAAS login context parameters for SASL connections in the format used by JAAS configuration files.|

# Kafka Source 

This is the repository for the Kafka source connector.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/kafka).

## Local development

#### Building via Gradle
From the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-kafka:build
```

#### Create credentials
**If you are a community contributor**, generate the necessary credentials and place them in `secrets/config.json` conforming to the spec file in `src/main/resources/spec.json`.
Note that the `secrets` directory is git-ignored by default, so there is no danger of accidentally checking in sensitive information.

**If you are an Airbyte core member**, follow the [instructions](https://docs.airbyte.io/connector-development#using-credentials-in-ci) to set up the credentials.

### Locally running the connector docker image

#### Build
Build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-kafka:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-kafka:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-kafka:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-kafka:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-kafka:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```

## Testing
We use `JUnit` for Java tests.

### Unit and Integration Tests
Place unit tests under `src/test/io/airbyte/integrations/source/kafka`.

#### Acceptance Tests
Airbyte has a standard test suite that all source connectors must pass.

### Using gradle to run tests
All commands should be run from airbyte project root. To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-kafka:integrationTest
```

## Dependency Management

### Publishing a new version of the connector
You've checked out the repo, implemented a million dollar feature, and you're ready to share your changes with the world. Now what?
1. Make sure your changes are passing unit and integration tests.
1. Bump the connector version in `Dockerfile` -- just increment the value of the `LABEL io.airbyte.version` appropriately (we use [SemVer](https://semver.org/)).
1. Create a Pull Request.
1. Pat yourself on the back for being an awesome contributor.
1. Someone from Airbyte will take a look at your PR and iterate with you to merge it into master.