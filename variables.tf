variable "infrastructure_configuration_file" {
  type        = string
  description = "The path to the configuration file for the infrastructure project. It should be in JSON or YAML."
}

variable "topics_directory" {
  type        = string
  description = "The path to the directory containing the generated topic configurations."
}

variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID in which resources will be placed. Defaults to the `google.project` configuration."
  default     = null
}

variable "gcp_region" {
  type        = string
  description = "The GCP region in which resources will be placed. Defaults to the `google.region` configuration."
  default     = null
}

variable "bigquery_location" {
  type        = string
  description = "The location of the BigQuery datasets. Defaults to the `google.pubSub.bigQueryStorage.location` configuration."
  default     = null
}

variable "bigquery_raw_events_dataset" {
  type        = string
  description = "The ID of the BigQuery dataset containing the raw Pub/Sub messages for event topics. Defaults to the `google.pubSub.bigQueryStorage.rawEventsDatasetId` configuration."
  default     = null
}

variable "deletion_protection" {
  type        = bool
  description = "Whether the BigQuery tables are protected against deletion. Defaults to `true`."
  default     = true
}

variable "bigquery_raw_events_data_type" {
  type        = string
  description = "The type of the `data` column in the raw events BigQuery tables. Can be `STRING`, `BYTES`, or `JSON`. Defaults to `JSON` if the `events.format` configuration is `json`, or `BYTES` otherwise."
  default     = null
}

variable "bigquery_raw_events_attributes_type" {
  type        = string
  description = "The type of the `attributes` column in the raw events BigQuery tables. Can be `JSON` or `STRING`. Defaults to `JSON`."
  default     = "JSON"
}
