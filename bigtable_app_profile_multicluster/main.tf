resource "google_bigtable_instance" "instance" {
  name = "bt-instance-${local.name_suffix}"
  cluster {
    cluster_id   = "cluster-1"
    zone         = "us-central1-a"
    num_nodes    = 3
    storage_type = "HDD"
  }
  cluster {
    cluster_id   = "cluster-2"
    zone         = "us-central1-b"
    num_nodes    = 3
    storage_type = "HDD"
  }
  cluster {
    cluster_id   = "cluster-3"
    zone         = "us-central1-c"
    num_nodes    = 3
    storage_type = "HDD"
  }

  deletion_protection  = "false"
}

resource "google_bigtable_app_profile" "ap" {
  instance       = google_bigtable_instance.instance.name
  app_profile_id = "bt-profile-${local.name_suffix}"

  // Requests will be routed to the following 2 clusters.
  multi_cluster_routing_use_any = true
  multi_cluster_routing_cluster_ids = ["cluster-1", "cluster-2"]

  ignore_warnings               = true
}
