locals {
  topic_configuration_files = [
    for configuration in fileset(var.topics_directory, "*.{json,yaml}") :
    yamldecode(file("${var.topics_directory}/${configuration}"))
  ]
  topic_configurations = {
    for configuration in local.topic_configuration_files :
    configuration.id => configuration
  }
}

# The Pub/Sub topic for each configuration.
resource "google_pubsub_topic" "topic" {
  for_each = local.topic_configurations

  project = local.gcp_project_id
  name    = each.value.id

  message_storage_policy {
    allowed_persistence_regions = [
      local.gcp_region
    ]
  }
}
