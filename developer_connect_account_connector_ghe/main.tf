resource "google_secret_manager_secret" "ghe_ac_client_id" {
  secret_id = "ghe-ac-id-${local.name_suffix}"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "ghe_ac_client_id_version" {
  secret = google_secret_manager_secret.ghe_ac_client_id.name
  secret_data = "dummy-client-id"
}

resource "google_secret_manager_secret" "ghe_ac_client_secret" {
  secret_id = "ghe-ac-sec-${local.name_suffix}"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "ghe_ac_client_secret_version" {
  secret = google_secret_manager_secret.ghe_ac_client_secret.name
  secret_data = "dummy-client-secret"
}

resource "google_developer_connect_account_connector" "my-account-connector" {
  location = "us-central1"
  account_connector_id = "my-ac-${local.name_suffix}"

  custom_oauth_config {
    auth_uri = "https://ghe.proctor-staging-test.com/login/oauth/authorize"
    client_id = google_secret_manager_secret_version.ghe_ac_client_id_version.secret_data
    client_secret = google_secret_manager_secret_version.ghe_ac_client_secret_version.secret_data
    token_uri = "https://ghe.proctor-staging-test.com/login/oauth/access_token"
    host_uri = "https://ghe.proctor-staging-test.com"
    scm_provider = "GITHUB_ENTERPRISE"
    scopes = ["repo"]
  }

  lifecycle {
    ignore_changes = [
      # Terraform should ignore changes to the client_secret field because
      # the API does not return it (INPUT_ONLY).
      custom_oauth_config[0].client_secret,
    ]
  }
}
