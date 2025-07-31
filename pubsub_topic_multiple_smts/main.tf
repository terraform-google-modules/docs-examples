locals {
  smts = [
    {
      function_name = "redactSSN"
      code = <<EOF
function redactSSN(message, metadata) {
  const data = JSON.parse(message.data);
  delete data['ssn'];
  message.data = JSON.stringify(data);
  return message;
}
EOF
    },
    {
      function_name = "otherFunc",
      code = <<EOF
function otherFunc(message, metadata) {
  return null;
}
EOF
    },
    {
      function_name = "someSMTWeDisabled",
      code = "..."
      disabled = true
    }
  ]
}

resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"

  dynamic "message_transforms" {
    for_each = local.smts

    content {
      disabled = lookup(message_transforms.value, "disabled", null)
      javascript_udf {
        function_name = message_transforms.value.function_name
        code = message_transforms.value.code
      }
    }
  }
}
