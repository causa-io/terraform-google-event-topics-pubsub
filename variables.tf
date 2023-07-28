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
