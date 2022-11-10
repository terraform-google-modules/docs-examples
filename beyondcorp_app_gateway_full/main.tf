resource "google_beyondcorp_app_gateway" "app_gateway" {
  name = "my-app-gateway-${local.name_suffix}"
  type = "TCP_PROXY"
  region = "us-central1"
  display_name = "some display name-${local.name_suffix}"
  labels = {
    foo = "bar"
    bar = "baz"
  }
  host_type = "GCP_REGIONAL_MIG"
}
