data "google_project" "test_project" {
}

resource "google_secret_manager_secret" "secret-basic" {
  secret_id     = "test-secret-${local.name_suffix}"
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}


resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret = google_secret_manager_secret.secret-basic.id
  secret_data = "dummypassword"
}

resource "google_secret_manager_secret_iam_member" "secret_iam" {
  secret_id  = google_secret_manager_secret.secret-basic.id
  role       = "roles/secretmanager.admin"
  member     = "serviceAccount:${data.google_project.test_project.number}-compute@developer.gserviceaccount.com"
  depends_on = [google_secret_manager_secret_version.secret-version-basic]
}

resource "google_integration_connectors_connection" "boxconnection" {
  name     = "test-box-${local.name_suffix}"
  location = "us-central1"
  connector_version = "projects/${data.google_project.test_project.project_id}/locations/global/providers/box/connectors/box/versions/1"
  service_account = "${data.google_project.test_project.number}-compute@developer.gserviceaccount.com"
  description = "tf created description"
  config_variable {
      key = "impersonate_user_mode"
      string_value = "User"
  }
  config_variable {
      key = "proxy_enabled"
      boolean_value = false
  }
  auth_config {
    auth_type = "OAUTH2_JWT_BEARER"
    oauth2_jwt_bearer {
      client_key {
        secret_version = google_secret_manager_secret_version.secret-version-basic.name
      }
      jwt_claims {
        issuer = "test"
        subject = "johndoe@example.org"
        audience  = "test"
      }
    }
  }
}
