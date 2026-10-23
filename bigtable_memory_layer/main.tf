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

resource "google_bigtable_app_profile" "ap" {
  instance       = google_bigtable_instance.instance.name
  app_profile_id = "bt-profile-${local.name_suffix}"

  single_cluster_routing {
    cluster_id                 = google_bigtable_memory_layer.memory_layer.cluster
    allow_transactional_writes = true
  }

  standard_isolation {
    priority = "PRIORITY_LOW"
    memory_config {}
  }

  ignore_warnings = true
}
