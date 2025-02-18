resource "google_spanner_instance" "main" {
  name         = "test-instance-${local.name_suffix}"
  config       = "nam6"
  display_name = "main-instance"
  num_nodes    = 1
  edition     = "ENTERPRISE_PLUS"
}

resource "google_spanner_instance_partition" "partition" {
  name         = "test-partition-${local.name_suffix}"
  instance     = google_spanner_instance.main.name
  config       = "nam8"
  display_name = "test-spanner-partition"
  node_count   = 1
} 
