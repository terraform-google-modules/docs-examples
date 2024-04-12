data "google_project" "project" {}

resource "google_secret_manager_secret" "example-remote-secret-${local.name_suffix}" {
  secret_id = "example-secret-${local.name_suffix}"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "example-remote-secret-${local.name_suffix}_version" {
  secret = google_secret_manager_secret.example-remote-secret-${local.name_suffix}.id
  secret_data = "remote-password-${local.name_suffix}"
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  secret_id = google_secret_manager_secret.example-remote-secret-${local.name_suffix}.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}

resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  repository_id = "example-python-custom-remote-${local.name_suffix}"
  description   = "example remote custom python repository with credentials-${local.name_suffix}"
  format        = "PYTHON"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    description = "custom npm with credentials"
    disable_upstream_validation = true
    python_repository {
      custom_repository {
        uri = "https://my.python.registry"
      }
    }
    upstream_credentials {
      username_password_credentials {
        username = "remote-username-${local.name_suffix}"
        password_secret_version = google_secret_manager_secret_version.example-remote-secret-${local.name_suffix}_version.name
      }
    }
  }
}
