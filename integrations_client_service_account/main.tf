data "google_project" "default" {
}

resource "google_service_account" "service_account" {
  account_id   = "service-acc-${local.name_suffix}"
  display_name = "Service Account"
}

resource "google_integrations_client" "example" {
  location = "asia-east1"
  run_as_service_account = google_service_account.service_account.email
}
