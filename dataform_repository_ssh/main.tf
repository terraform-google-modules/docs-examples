resource "google_sourcerepo_repository" "git_repository" {
  provider = google-beta
  name = "my/repository-${local.name_suffix}"
}

resource "google_secret_manager_secret" "secret" {
  provider = google-beta
  secret_id = "my-secret-${local.name_suffix}"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  provider = google-beta
  secret = google_secret_manager_secret.secret.id

  secret_data = "secret-data-${local.name_suffix}"
}

resource "google_dataform_repository" "dataform_respository" {
  provider = google-beta
  name = "dataform_repository-${local.name_suffix}"

  git_remote_settings {
      url = google_sourcerepo_repository.git_repository.url
      default_branch = "main"
      ssh_authentication_config {
        user_private_key_secret_version = google_secret_manager_secret_version.secret_version.id
        host_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU"
      }
  }

  workspace_compilation_overrides {
    default_database = "database"
    schema_suffix = "_suffix"
    table_prefix = "prefix_"
  }

  service_account = "1234567890-compute@developer.gserviceaccount.com"
}
