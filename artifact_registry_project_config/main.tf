resource "google_artifact_registry_project_config" "my-config" {
  location = "us-central1"
  platform_logs_config {
    logging_state  = "ENABLED"
    severity_level = "INFO"
  }
}
