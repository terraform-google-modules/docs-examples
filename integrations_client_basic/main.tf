resource "google_integrations_client" "example" {
  location = "us-central1"
  provision_gmek = true
}
