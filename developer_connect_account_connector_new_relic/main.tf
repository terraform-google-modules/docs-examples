resource "google_developer_connect_account_connector" "my-account-connector" {
  location = "us-central1"
  account_connector_id = "tf-test-ac-${local.name_suffix}"

  provider_oauth_config {
    system_provider_id = "NEW_RELIC"
    scopes = []
  }
}
