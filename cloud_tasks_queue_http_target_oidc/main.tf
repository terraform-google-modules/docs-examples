resource "google_cloud_tasks_queue" "http_target_oidc" {
  name     = "cloud-tasks-queue-http-target-oidc-${local.name_suffix}"
  location = "us-central1"

  http_target {
    http_method = "POST"
    uri_override {
      scheme = "HTTPS"
      host   = "oidc.example.com"
      port   = 8443
      path_override {
        path = "/users/1234"
      }
      query_override {
        query_params = "qparam1=123&qparam2=456"
      }
      uri_override_enforce_mode = "IF_NOT_EXISTS"
    }
    header_overrides {
      header {
        key   = "AddSomethingElse"
        value = "MyOtherValue"
      }
    }
    header_overrides {
      header {
        key   = "AddMe"
        value = "MyValue"
      }
    }
    oidc_token {
      service_account_email = google_service_account.oidc_service_account.email
      audience              = "https://oidc.example.com"
    }
  }
}

resource "google_service_account" "oidc_service_account" {
  account_id   = "example-oidc"
  display_name = "Tasks Queue OIDC Service Account"
}