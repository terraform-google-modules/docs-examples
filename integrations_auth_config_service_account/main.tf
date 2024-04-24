resource "google_integrations_client" "client" {
  location = "northamerica-northeast1"
}

resource "google_service_account" "service_account" {
  account_id   = "sa-${local.name_suffix}"
  display_name = "Service Account"
}

resource "google_integrations_auth_config" "service_account_example" {
    location = "northamerica-northeast1"
    display_name = "test-authconfig-service-account-${local.name_suffix}"
    description = "Test auth config created via terraform"
    decrypted_credential {
        credential_type = "SERVICE_ACCOUNT"
        service_account_credentials {
            service_account = google_service_account.service_account.email
            scope = "https://www.googleapis.com/auth/cloud-platform https://www.googleapis.com/auth/adexchange.buyer https://www.googleapis.com/auth/admob.readonly"
        }
    }
    depends_on = [google_service_account.service_account, google_integrations_client.client]
}
