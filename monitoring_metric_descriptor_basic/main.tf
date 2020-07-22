resource "google_monitoring_metric_descriptor" "basic" {
  description = "Daily sales records from all branch stores."
  display_name = "metric-descriptor-${local.name_suffix}"
  type = "custom.googleapis.com/stores/daily_sales-${local.name_suffix}"
  metric_kind = "GAUGE"
  value_type = "DOUBLE"
  unit = "{USD}"
  labels {
      key = "store_id"
      value_type = "STRING"
      description = "The ID of the store."
  }
  launch_stage = "BETA"
  metadata {
    sample_period = "60s"
    ingest_delay = "30s"
  }
}
