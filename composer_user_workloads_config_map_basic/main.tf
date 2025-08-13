data "google_project" "project" {}

resource "google_service_account" "test" {
  account_id   = "test-sa-${local.name_suffix}"
  display_name = "Test Service Account for Composer Environment"
}

resource "google_project_iam_member" "composer-worker" {
  project = data.google_project.project.project_id
  role   = "roles/composer.worker"
  member = "serviceAccount:${google_service_account.test.email}"
}

resource "google_composer_environment" "environment" {
  name   = "test-environment-${local.name_suffix}"
  region = "us-central1"
  config {
    software_config {
      image_version = "composer-3-airflow-2"
    }
    node_config {
      service_account = google_service_account.test.name
    }
  }
  depends_on = [google_project_iam_member.composer-worker]
}

resource "google_composer_user_workloads_config_map" "config_map" {
  name = "test-config-map-${local.name_suffix}"
  region = "us-central1"
  environment = google_composer_environment.environment.name
  data = {
    api_host: "apihost:443",
  }
}
