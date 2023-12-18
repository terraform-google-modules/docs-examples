resource "google_integration_connectors_endpoint_attachment" "sampleendpointattachment" {
  name     = "test-endpoint-attachment-${local.name_suffix}"
  location = "us-central1"
  description = "tf created description"
  service_attachment = "projects/connectors-example/regions/us-central1/serviceAttachments/test"
  labels = {
    foo = "bar"
  }
}
