resource "google_vertex_ai_evaluation_metric" "example" {
  evaluation_metric_id = "example-metric-full-${local.name_suffix}"
  region               = "us-central1"
  display_name         = "Full Test Evaluation Metric"
  description          = "An evaluation metric with all fields for Terraform acceptance testing"

  metric = jsonencode({
    llmBasedMetricSpec = {
      metricPromptTemplate = "Rate the quality of the following response on a scale of 1 to 5. Response: {response}"
    }
  })

  labels = {
    env  = "test"
    team = "evaluation"
  }

  encryption_spec {
    kms_key_name = "kms-key-${local.name_suffix}"
  }

  gcs_uri = "gs://eval-metric-test-bucket-${local.name_suffix}/metric-spec.json"
}

resource "google_storage_bucket" "metric_bucket" {
  name                        = "eval-metric-test-bucket-${local.name_suffix}"
  location                    = "us-central1"
  uniform_bucket_level_access = true
  force_destroy               = true
}
