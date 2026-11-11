resource "google_vertex_ai_custom_job" "custom_job" {
  display_name = "example-custom-job-models-${local.name_suffix}"
  region       = "us-central1"

  job_spec {
    protected_artifact_location_id = "us-central1"
    models                         = ["example-model-${local.name_suffix}"]

    worker_pool_specs {
      replica_count = 1

      machine_spec {
        machine_type = "n1-standard-4"
      }

      disk_spec {
        boot_disk_type    = "pd-ssd"
        boot_disk_size_gb = 100
      }

      container_spec {
        image_uri = "us-docker.pkg.dev/vertex-ai-restricted/llm/llm-pets-cpu:latest"
      }
    }
  }
}
