resource "google_apphub_application" "example" {
  location = "us-east1"
  application_id = "example-application-${local.name_suffix}"
  scope {
    type = "REGIONAL"
  }
}
