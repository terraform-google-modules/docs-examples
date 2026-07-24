data "google_project" "project" {}

resource "google_storage_bucket" "bucket" {
  name                        = "pipeline-job-${local.name_suffix}"
  location                    = "us-central1"
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_compute_network" "my_network" {
  name                    = "colab-test-default-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_colab_schedule" "schedule" {
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
    parent          = "projects/${data.google_project.project.project_id}/locations/us-central1"
    pipeline_job {
      display_name          = "test-pipeline-job"
      preflight_validations = true
      network               = google_compute_network.my_network.id
      service_account       = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
      template_uri          = "https://us-kfp.pkg.dev/proj/repo/template/v1"
      reserved_ip_ranges    = ["vertex-ai-ip-range"]

      labels = {
        "key" = "value-one"
      }

      encryption_spec {
        kms_key_name = "my-key-${local.name_suffix}"
      }

      psc_interface_config {
        network_attachment = "projects/${data.google_project.project.project_id}/regions/us-central1/networkAttachments/my-attachment"
        dns_peering_configs {
          domain         = "my-internal-domain.corp."
          target_network = google_compute_network.my_network.id
          target_project = data.google_project.project.project_id
        }
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
        parameter_values     = {
          param1 = "val1"
        }
      }
    }
  }
}
