locals {
  # Project configuration from the JSON file.
  configuration = yamldecode(file(var.infrastructure_configuration_file))

  conf_google         = try(local.configuration.google, tomap({}))
  conf_google_project = try(local.conf_google.project, null)
  conf_google_region  = try(local.conf_google.region, null)

  # Configuration with variable overrides.
  gcp_project_id = coalesce(var.gcp_project_id, local.conf_google_project)
  gcp_region     = coalesce(var.gcp_region, local.conf_google_region)
}
