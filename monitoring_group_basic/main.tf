resource "google_monitoring_group" "basic" {
  display_name = "tf-test MonitoringGroup-${local.name_suffix}"

  filter = "resource.metadata.region=\"europe-west2\""
}
