output "topic_ids" {
  description = "A map where keys are topic full names and values are Pub/Sub topic IDs."
  value = {
    for topic_full_name, topic in google_pubsub_topic.topic :
    topic_full_name => topic.id
  }
}
