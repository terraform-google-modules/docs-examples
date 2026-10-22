resource "google_bigtable_instance" "instance" {
  name          = "bt-instance-${local.name_suffix}"
  instance_type = "PRODUCTION"
  edition       = "ENTERPRISE_PLUS"
  cluster {
    cluster_id   = "bt-cluster-${local.name_suffix}"
    zone         = "us-central1-b"
    num_nodes    = 1
    storage_type = "SSD"
  }

  deletion_protection = false
}

resource "google_bigtable_memory_layer" "memory_layer" {
  instance = google_bigtable_instance.instance.name
  cluster  = google_bigtable_instance.instance.cluster[0].cluster_id
}
