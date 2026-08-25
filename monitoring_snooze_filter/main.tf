resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "My Alert Policy-${local.name_suffix}"
  combiner     = "OR"
  conditions {
    display_name = "test condition"
    condition_threshold {
      filter     = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
}

resource "google_monitoring_snooze" "snooze" {
  display_name = "My Snooze-${local.name_suffix}"

  interval {
    start_time = "2024-02-03T07:44:12Z-${local.name_suffix}"
    end_time   = "2024-02-05T07:44:12Z-${local.name_suffix}"
  }

  criteria {
    policies = [
      google_monitoring_alert_policy.alert_policy.id
    ]
    filter = "resource.labels.instance_id=\"1234567890\""
  }
}
