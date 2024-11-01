# Source gnews

## Example
```json
{
  "api_key": "your_api_key",
  "query": "Microsoft Windows 10",
  "language": "en",
  "country": "us",
  "in": [
    "title",
    "description"
  ],
  "nullable": [
    "content"
  ],
  "start_date": "2022-08-21 00:00:00",
  "sortby": "publishedAt",
  "top_headlines_query": "Apple OR Microsoft",
  "top_headlines_topic": "technology"
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|api_key|string||null|API Key|
|query|string||null|This parameter allows you to specify your search keywords to find the news articles you are looking for. The keywords will be used to return the most relevant articles. It is possible to use logical operators  with keywords. - Phrase Search Operator: This operator allows you to make an exact search. Keywords surrounded by 
  quotation marks are used to search for articles with the exact same keyword sequence. 
  For example the query: "Apple iPhone" will return articles matching at least once this sequence of keywords.
- Logical AND Operator: This operator allows you to make sure that several keywords are all used in the article
  search. By default the space character acts as an AND operator, it is possible to replace the space character 
  by AND to obtain the same result. For example the query: Apple Microsoft is equivalent to Apple AND Microsoft
- Logical OR Operator: This operator allows you to retrieve articles matching the keyword a or the keyword b.
  It is important to note that this operator has a higher precedence than the AND operator. For example the 
  query: Apple OR Microsoft will return all articles matching the keyword Apple as well as all articles matching 
  the keyword Microsoft
- Logical NOT Operator: This operator allows you to remove from the results the articles corresponding to the
  specified keywords. To use it, you need to add NOT in front of each word or phrase surrounded by quotes.
  For example the query: Apple NOT iPhone will return all articles matching the keyword Apple but not the keyword
  iPhone|
|language|string||null||
|country|string||null|This parameter allows you to specify the country where the news articles returned by the API were published, the contents of the articles are not necessarily related to the specified country. You have to set as value the 2 letters code of the country you want to filter.|
|in|array||null|This parameter allows you to choose in which attributes the keywords are searched. The attributes that can be set are title, description and content. It is possible to combine several attributes.|
|nullable|array||null|This parameter allows you to specify the attributes that you allow to return null values. The attributes that  can be set are title, description and content. It is possible to combine several attributes|
|start_date|string||null|This parameter allows you to filter the articles that have a publication date greater than or equal to the  specified value. The date must respect the following format: YYYY-MM-DD hh:mm:ss (in UTC)|
|end_date|string||null|This parameter allows you to filter the articles that have a publication date smaller than or equal to the  specified value. The date must respect the following format: YYYY-MM-DD hh:mm:ss (in UTC)|
|sortby|string||null|This parameter allows you to choose with which type of sorting the articles should be returned. Two values  are possible:
  - publishedAt = sort by publication date, the articles with the most recent publication date are returned first
  - relevance = sort by best match to keywords, the articles with the best match are returned first|
|top_headlines_query|string||null|This parameter allows you to specify your search keywords to find the news articles you are looking for. The keywords will be used to return the most relevant articles. It is possible to use logical operators  with keywords. - Phrase Search Operator: This operator allows you to make an exact search. Keywords surrounded by 
  quotation marks are used to search for articles with the exact same keyword sequence. 
  For example the query: "Apple iPhone" will return articles matching at least once this sequence of keywords.
- Logical AND Operator: This operator allows you to make sure that several keywords are all used in the article
  search. By default the space character acts as an AND operator, it is possible to replace the space character 
  by AND to obtain the same result. For example the query: Apple Microsoft is equivalent to Apple AND Microsoft
- Logical OR Operator: This operator allows you to retrieve articles matching the keyword a or the keyword b.
  It is important to note that this operator has a higher precedence than the AND operator. For example the 
  query: Apple OR Microsoft will return all articles matching the keyword Apple as well as all articles matching 
  the keyword Microsoft
- Logical NOT Operator: This operator allows you to remove from the results the articles corresponding to the
  specified keywords. To use it, you need to add NOT in front of each word or phrase surrounded by quotes.
  For example the query: Apple NOT iPhone will return all articles matching the keyword Apple but not the keyword
  iPhone|
|top_headlines_topic|string||null|This parameter allows you to change the category for the request.|

# Gnews Source

This is the repository for the Gnews configuration based source connector.
For information about how to use this connector within Airbyte, see [the documentation](https://docs.airbyte.io/integrations/sources/gnews).

## Local development

#### Building via Gradle
You can also build the connector in Gradle. This is typically used in CI and not needed for your development workflow.

To build using Gradle, from the Airbyte repository root, run:
```
./gradlew :airbyte-integrations:connectors:source-gnews:build
```

#### Create credentials
**If you are a community contributor**, follow the instructions in the [documentation](https://docs.airbyte.io/integrations/sources/gnews)
to generate the necessary credentials. Then create a file `secrets/config.json` conforming to the `source_gnews/spec.yaml` file.
Note that any directory named `secrets` is gitignored across the entire Airbyte repo, so there is no danger of accidentally checking in sensitive information.
See `integration_tests/sample_config.json` for a sample config file.

**If you are an Airbyte core member**, copy the credentials in Lastpass under the secret name `source gnews test creds`
and place them into `secrets/config.json`.

### Locally running the connector docker image

#### Build
First, make sure you build the latest Docker image:
```
docker build . -t airbyte/source-gnews:dev
```

You can also build the connector image via Gradle:
```
./gradlew :airbyte-integrations:connectors:source-gnews:airbyteDocker
```
When building via Gradle, the docker image name and tag, respectively, are the values of the `io.airbyte.name` and `io.airbyte.version` `LABEL`s in
the Dockerfile.

#### Run
Then run any of the connector commands as follows:
```
docker run --rm airbyte/source-gnews:dev spec
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-gnews:dev check --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets airbyte/source-gnews:dev discover --config /secrets/config.json
docker run --rm -v $(pwd)/secrets:/secrets -v $(pwd)/integration_tests:/integration_tests airbyte/source-gnews:dev read --config /secrets/config.json --catalog /integration_tests/configured_catalog.json
```
## Testing

#### Acceptance Tests
Customize `acceptance-test-config.yml` file to configure tests. See [Connector Acceptance Tests](https://docs.airbyte.io/connector-development/testing-connectors/connector-acceptance-tests-reference) for more information.
If your connector requires to create or destroy resources for use during acceptance tests create fixtures for it and place them inside integration_tests/acceptance.py.

To run your integration tests with docker

### Using gradle to run tests
All commands should be run from airbyte project root.
To run unit tests:
```
./gradlew :airbyte-integrations:connectors:source-gnews:unitTest
```
To run acceptance and custom integration tests:
```
./gradlew :airbyte-integrations:connectors:source-gnews:integrationTest
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
