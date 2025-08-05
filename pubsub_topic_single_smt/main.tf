resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"

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
