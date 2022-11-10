resource "google_service_account" "service_account" {
  account_id   = "my-account-${local.name_suffix}"
  display_name = "Test Service Account"
}

resource "google_beyondcorp_app_connector" "app_connector" {
  name = "my-app-connector-${local.name_suffix}"
  principal_info {
    service_account {
     email = google_service_account.service_account.email
    }
  }
}
