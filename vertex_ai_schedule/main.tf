data "google_project" "project" {}

resource "google_storage_bucket" "bucket" {
  name                        = "pipeline-job-${local.name_suffix}"
  location                    = "us-central1"
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_vertex_ai_schedule" "schedule" {
  display_name                    = "test-schedule"
  location                        = "us-central1"
  max_concurrent_run_count        = 2
  cron                            = "*/5 * * * *"
  allow_queueing                  = true
  max_concurrent_active_run_count = 2
  max_run_count                   = "10"
  start_time                      = "2030-01-01T00:00:00Z"
  end_time                        = "2030-01-02T00:00:00Z"

  create_pipeline_job_request {
    parent = "projects/${data.google_project.project.project_id}/locations/us-central1"
    pipeline_job {
      display_name          = "test-pipeline-job"
      preflight_validations = true
      labels = {
        "key" = "value-one"
      }
      pipeline_spec = jsonencode({
        pipelineInfo = {
          name = "hello-world"
        }
        root = {
          dag = {
            tasks = {}
          }
        }
        schemaVersion = "2.1.0"
        sdkVersion    = "kfp-2.0.0"
      })

      runtime_config {
        gcs_output_directory = "gs://${google_storage_bucket.bucket.name}/pipeline_root"
        failure_policy       = "PIPELINE_FAILURE_POLICY_FAIL_FAST"
      }
    }
  }
}
