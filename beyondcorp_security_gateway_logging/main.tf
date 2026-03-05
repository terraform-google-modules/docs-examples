resource "google_beyondcorp_security_gateway" "example-logging" {
  security_gateway_id = "default-logging-${local.name_suffix}"
  display_name = "My Security Gateway resource with logging enabled"
  hubs { region = "us-central1" }
  logging {}
}
