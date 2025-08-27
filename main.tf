locals {
  # Project configuration from the JSON file.
  configuration = yamldecode(file(var.infrastructure_configuration_file))

  conf_google                      = try(local.configuration.google, tomap({}))
  conf_google_project              = try(local.conf_google.project, null)
  conf_google_region               = try(local.conf_google.region, null)
  conf_pubsub                      = try(local.conf_google.pubSub, tomap({}))
  conf_bigquery_storage            = try(local.conf_pubsub.bigQueryStorage, tomap({}))
  conf_bigquery_location           = try(local.conf_bigquery_storage.location, null)
  conf_bigquery_raw_events_dataset = try(local.conf_bigquery_storage.rawEventsDatasetId, tomap({}))
  conf_events                      = try(local.configuration.events, tomap({}))
  conf_events_format               = try(local.conf_events.format, null)

  # Configuration with variable overrides.
  gcp_project_id                = coalesce(var.gcp_project_id, local.conf_google_project)
  gcp_region                    = coalesce(var.gcp_region, local.conf_google_region)
  bigquery_location             = try(coalesce(var.bigquery_location, local.conf_bigquery_location), null)
  bigquery_raw_events_dataset   = try(coalesce(var.bigquery_raw_events_dataset, local.conf_bigquery_raw_events_dataset), null)
  bigquery_raw_events_data_type = coalesce(var.bigquery_raw_events_data_type, local.conf_events_format == "json" ? "JSON" : "BYTES")
}

data "google_project" "project" {
  project_id = local.gcp_project_id
}
