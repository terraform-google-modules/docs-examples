resource "google_vertex_ai_evaluation_metric" "example" {
  evaluation_metric_id = "example-metric-${local.name_suffix}"
  region               = "us-central1"
  display_name         = "Test Evaluation Metric"
  description          = "An evaluation metric for Terraform acceptance testing"

  metric = jsonencode({
    llmBasedMetricSpec = {
      metricPromptTemplate = "Rate the quality of the following response on a scale of 1 to 5. Response: {response}"
    }
  })
}
