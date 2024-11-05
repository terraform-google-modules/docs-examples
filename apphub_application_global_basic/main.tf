resource "google_apphub_application" "example" {
  location = "global-${local.name_suffix}"
  application_id = "example-application-${local.name_suffix}"
  scope {
    type = "GLOBAL-${local.name_suffix}"
  }
}
