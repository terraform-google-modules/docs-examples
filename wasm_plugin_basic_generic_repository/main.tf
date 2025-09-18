data "google_project" "project" {}

resource "google_network_services_wasm_plugin" "wasm_plugin" {
  name        = "my-wasm-plugin-${local.name_suffix}"
  description = "my wasm plugin from a generic repository"

  main_version_id = "v1"

  labels = {
    test_label =  "test_value"
  }
  log_config {
    enable =  true
    sample_rate = 1
    min_log_level =  "WARN"
  }

  versions {
    version_name = "v1"
    description = "v1 version of my wasm plugin"
    image_uri = "projects/${data.google_project.project.name}/locations/us-central1/repositories/{index $.Vars "repository_name"}/genericArtifacts/{index $.Vars "plugin_package_name"}:v1"

    labels = {
      test_label =  "test_value"
    }
  }
}
