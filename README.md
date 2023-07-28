# Terraform module for Pub/Sub topics management

This Terraform module manages a Causa workspace's event topics, created as Pub/Sub topics. Optionally, it can also manage the data warehouse for those events, in the form of BigQuery tables. The module relies on the [`ProjectWriteConfigurations`](https://github.com/causa-io/workspace-module-core#projectwriteconfigurations) and [`GooglePubSubWriteTopics`](https://github.com/causa-io/workspace-module-google#googlepubsubwritetopics) infrastructure processors to generate the configuration for the topics and BigQuery tables.

## ➕ Requirements

This module depends on the [google Terraform provider](https://registry.terraform.io/providers/hashicorp/google/latest).

## 🎉 Installation

Copy the following in your Terraform configuration, and run `terraform init`:

```terraform
module "my_service" {
  source  = "causa-io/event-topics-pubsub/google"
  version = "<insert the most recent version number here>"

  # The path to the generated configuration file for the infrastructure project.
  infrastructure_configuration_file = "${local.project_configurations_directory}/infrastructure.json"
  # The path to the generated topics configurations.
  topics_directory                  = "${local.causa_directory}/pubsub-topics"
}
```

## ✨ Features

### Pub/Sub topics

A Pub/Sub topic is created and managed for each topic configuration file written by the [`GooglePubSubWriteTopics`](https://github.com/causa-io/workspace-module-google#googlepubsubwritetopics) processor at the location set in the `topics_directory` Terraform variable. The event topics are found in the workspace as defined in the `events.topics` configuration.

### Raw BigQuery tables

If the `google.pubSub.bigQueryStorage.rawEventsDatasetId` configuration (or the `bigquery_raw_events_dataset` Terraform variable) is set, a BigQuery table will automatically be created for each topic, and a Pub/Sub BigQuery subscription will be configured to pipe all events to the table.

### Deletion protection

The `deletion_protection` Terraform variable defaults to `true` and protects BigQuery tables against deletion. It must be set to `false` to be able to delete the tables.
