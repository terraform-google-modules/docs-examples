resource "google_beyondcorp_app_gateway" "app_gateway" {
  name = "my-app-gateway-${local.name_suffix}"
  type = "TCP_PROXY"
  region = "us-central1"
  host_type = "GCP_REGIONAL_MIG"
}
