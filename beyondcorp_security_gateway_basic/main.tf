resource "google_beyondcorp_security_gateway" "example" {
  security_gateway_id = "default-${local.name_suffix}"
  location = "global"
  display_name = "My Security Gateway resource"
  hubs { region = "us-central1" }
}
