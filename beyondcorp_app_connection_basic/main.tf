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

resource "google_beyondcorp_app_connection" "app_connection" {
  name = "my-app-connection-${local.name_suffix}"
  type = "TCP_PROXY"
  application_endpoint {
    host = "foo-host"
    port = 8080
  }
  connectors = [google_beyondcorp_app_connector.app_connector.id]
}
