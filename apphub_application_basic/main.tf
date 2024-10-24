resource "google_apphub_application" "example" {
  location = "us-east1-${local.name_suffix}"
  application_id = "example-application-${local.name_suffix}"
  scope {
    type = "REGIONAL-${local.name_suffix}"
  }
}
