output "topic_ids" {
  description = "A map where keys are topic full names and values are Pub/Sub topic IDs."
  value = {
    for topic_full_name, topic in google_pubsub_topic.topic :
    topic_full_name => topic.id
  }
}

output "bigquery_events_raw_dataset_id" {
  description = "The ID of the BigQuery dataset containing the raw Pub/Sub messages for the event topics."
  value       = local.bigquery_raw_events_dataset != null ? google_bigquery_dataset.raw_events[0].dataset_id : null
}
