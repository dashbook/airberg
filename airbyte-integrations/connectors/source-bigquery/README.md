# Source bigquery

## Example
```json
{
  "project_id": "my-project-id",
  "dataset_id": "my-dataset-id",
  "credentials_json": "my-credentials-json"
}
```

## Configuration
| Name | Type | Constant | Default | Description |
| --- | --- | --- | --- | --- |
|project_id |string||null|The GCP project ID for the project containing the target BigQuery dataset.|
|dataset_id |string||null|The dataset ID to search for tables and views. If you are only loading data from one dataset, setting this option could result in much faster schema discovery.|
|credentials_json |string||null|The contents of your Service Account Key JSON file. See the <a href="https://docs.airbyte.com/integrations/sources/bigquery#setup-the-bigquery-source-in-airbyte">docs</a> for more information on how to obtain this key.|

# BigQuery Test Configuration

In order to test the BigQuery source, you need a service account key file.

## Community Contributor

As a community contributor, you will need access to a GCP project and BigQuery to run tests.

1. Go to the `Service Accounts` page on the GCP console
1. Click on `+ Create Service Account" button
1. Fill out a descriptive name/id/description
1. Click the edit icon next to the service account you created on the `IAM` page
1. Add the `BigQuery Data Editor` and `BigQuery User` role
1. Go back to the `Service Accounts` page and use the actions modal to `Create Key`
1. Download this key as a JSON file
1. Move and rename this file to `secrets/credentials.json`

## Airbyte Employee

1. Access the `BigQuery Integration Test User` secret on Rippling under the `Engineering` folder
1. Create a file with the contents at `secrets/credentials.json`
