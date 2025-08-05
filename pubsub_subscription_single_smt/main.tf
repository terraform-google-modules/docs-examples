resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"
}

resource "google_pubsub_subscription" "example" {
  name  = "example-subscription-${local.name_suffix}"
  topic = google_pubsub_topic.example.id

  message_transforms {
    javascript_udf {
      function_name = "isYearEven"
      code = <<EOF
function isYearEven(message, metadata) {
  const data = JSON.parse(message.data);
  return message.year %2 === 0;
}
EOF
    }
  }
}
