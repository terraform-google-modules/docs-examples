resource "google_bigtable_instance" "instance" {
  name = "bt-instance-${local.name_suffix}"
  cluster {
    cluster_id   = "cluster-1"
    zone         = "us-central1-b"
    num_nodes    = 3
    storage_type = "HDD"
  }

  deletion_protection  = "false"
}

resource "google_bigtable_app_profile" "ap" {
  instance       = google_bigtable_instance.instance.name
  app_profile_id = "bt-profile-${local.name_suffix}"

  // Requests will be routed to the following cluster.
  single_cluster_routing {
    cluster_id                 = "cluster-1"
    allow_transactional_writes = true
  }

  standard_isolation {
    priority = "PRIORITY_LOW"
  }

  ignore_warnings = true
}
