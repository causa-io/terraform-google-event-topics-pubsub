# The dataset for raw event tables piped directly from Pub/Sub to BigQuery.
resource "google_bigquery_dataset" "raw_events" {
  count = local.bigquery_raw_events_dataset != null ? 1 : 0

  project               = local.gcp_project_id
  dataset_id            = local.bigquery_raw_events_dataset
  friendly_name         = "Raw events from Pub/Sub"
  description           = "Dataset containing the raw events from Pub/Sub."
  location              = local.bigquery_location
  max_time_travel_hours = 48
}

# The permissions for Pub/Sub to write to BigQuery.
resource "google_bigquery_dataset_iam_member" "pubsub_raw_events_editor" {
  count = local.bigquery_raw_events_dataset != null ? 1 : 0

  project    = local.gcp_project_id
  dataset_id = google_bigquery_dataset.raw_events[0].dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_bigquery_dataset_iam_member" "pubsub_raw_events_metadata_viewer" {
  count = local.bigquery_raw_events_dataset != null ? 1 : 0

  project    = local.gcp_project_id
  dataset_id = google_bigquery_dataset.raw_events[0].dataset_id
  role       = "roles/bigquery.metadataViewer"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

# The BigQuery tables for raw events.
# They all have the same schema as Pub/Sub writes the entire payload in the `data` field.
resource "google_bigquery_table" "raw_events" {
  for_each = local.bigquery_raw_events_dataset != null ? local.topic_configurations : {}

  project       = local.gcp_project_id
  dataset_id    = google_bigquery_dataset.raw_events[0].dataset_id
  table_id      = each.value.bigQueryTableName
  description   = "Table for raw ${each.key} events."
  friendly_name = each.key

  schema = jsonencode([
    {
      mode        = "NULLABLE"
      name        = "subscription_name"
      type        = "STRING"
      description = "The name of the Pub/Sub subscription."
    },
    {
      mode        = "NULLABLE"
      name        = "message_id"
      type        = "STRING"
      description = "The ID of the Pub/Sub message."
    },
    {
      mode        = "NULLABLE"
      name        = "publish_time"
      type        = "TIMESTAMP"
      description = "The time of publishing of the message."
    },
    {
      mode        = "REQUIRED"
      name        = "data"
      type        = local.bigquery_raw_events_data_type
      description = "The payload of the event."
    },
    {
      mode        = "NULLABLE"
      name        = "attributes"
      type        = var.bigquery_raw_events_attributes_type
      description = "The dictionary of attributes for the message."
    }
  ])

  time_partitioning {
    field = "publish_time"
    type  = "DAY"
  }

  deletion_protection = var.deletion_protection
}

# The subscriptions automatically piping Pub/Sub events to BigQuery tables.
resource "google_pubsub_subscription" "bigquery" {
  for_each = google_bigquery_table.raw_events

  project = local.gcp_project_id
  name    = "bq-${each.key}"
  topic   = google_pubsub_topic.topic[each.key].id

  bigquery_config {
    table          = "${each.value.project}:${each.value.dataset_id}.${each.value.table_id}"
    write_metadata = true
  }

  expiration_policy {
    ttl = ""
  }

  depends_on = [
    google_bigquery_dataset_iam_member.pubsub_raw_events_editor,
    google_bigquery_dataset_iam_member.pubsub_raw_events_metadata_viewer,
  ]
}
