resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "My Alert Policy-${local.name_suffix}"
  combiner = "OR"
  conditions {
    display_name = "test condition"
    condition_threshold {
      filter = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\""
      duration = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  user_labels = {
    foo = "bar"
  }
}
