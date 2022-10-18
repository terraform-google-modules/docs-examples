resource "google_sourcerepo_repository" "git_repository" {
  provider = google-beta
  name = "my/repository-${local.name_suffix}"
}

resource "google_secret_manager_secret" "secret" {
  provider = google-beta
  secret_id = "secret"

  replication {
    automatic = true
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
      authentication_token_secret_version = google_secret_manager_secret_version.secret_version.id
  }
}
