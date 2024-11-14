resource "google_composer_environment" "environment" {
  name   = "test-environment-${local.name_suffix}"
  region = "us-central1"
  config {
    software_config {
      image_version = "composer-3-airflow-2"
    }
  }
}

resource "google_composer_user_workloads_config_map" "config_map" {
  name = "test-config-map-${local.name_suffix}"
  region = "us-central1"
  environment = google_composer_environment.environment.name
  data = {
    api_host: "apihost:443",
  }
}
