resource "google_sourcerepo_repository" "git_repository" {
  name     = "my/repository-${local.name_suffix}"
}

resource "google_secret_manager_secret" "secret" {
  secret_id = "my_secret-${local.name_suffix}"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  secret   = google_secret_manager_secret.secret.id

  secret_data = "secret-data-${local.name_suffix}"
}

resource "google_dataform_repository" "repository" {
  name     = "dataform_repository-${local.name_suffix}"
  region   = "us-central1"

  git_remote_settings {
      url = google_sourcerepo_repository.git_repository.url
      default_branch = "main"
      authentication_token_secret_version = google_secret_manager_secret_version.secret_version.id
  }

  workspace_compilation_overrides {
    default_database = "database"
    schema_suffix = "_suffix"
    table_prefix = "prefix_"
  }
}

resource "google_dataform_repository_release_config" "release" {

  project    = google_dataform_repository.repository.project
  region     = google_dataform_repository.repository.region
  repository = google_dataform_repository.repository.name

  name          = "my_release-${local.name_suffix}"
  git_commitish = "main"
  cron_schedule = "0 7 * * *"
  time_zone     = "America/New_York"
  disabled      = true
}
