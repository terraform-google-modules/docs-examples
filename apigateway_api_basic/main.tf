resource "google_api_gateway_api" "api" {
  provider = google-beta
  api_id = "api-${local.name_suffix}"
}
