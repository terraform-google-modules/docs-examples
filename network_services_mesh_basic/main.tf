resource "google_network_services_mesh" "default" {
  provider    = google-beta
  name        = "my-mesh-${local.name_suffix}"
  labels      = {
    foo = "bar"
  }
  description = "my description"
  interception_port = 443
}
