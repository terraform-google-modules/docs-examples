resource "google_integrations_client" "example" {
  location = "asia-south1"
  provision_gmek = true
  create_sample_workflows = true
}
