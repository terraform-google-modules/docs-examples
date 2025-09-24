resource "google_dialogflow_conversation_profile" "recognition_result_notification_profile" {
  display_name = "dialogflow-profile-${local.name_suffix}"
  location = "global"
  new_recognition_result_notification_config {
    topic = google_pubsub_topic.recognition_result_notification_profile.id
    message_format =  "JSON-${local.name_suffix}"
  }
}

resource "google_pubsub_topic" "recognition_result_notification_profile" {
  name = "recognition-result-notification-${local.name_suffix}"
}
