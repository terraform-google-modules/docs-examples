resource "google_service_account" "service_account" {
  account_id   = "my-account-${local.name_suffix}"
  display_name = "Test Service Account"
}

# wait for service account to propagate -- can be needed due to 
# SA eventual consistency issue
resource "time_sleep" "wait_120_seconds" {
  depends_on = [google_service_account.service_account]

  create_duration = "120s"
}


resource "google_beyondcorp_app_connector" "app_connector" {
  depends_on = [time_sleep.wait_120_seconds]

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
