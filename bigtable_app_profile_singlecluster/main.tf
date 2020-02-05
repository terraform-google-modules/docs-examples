resource "google_bigtable_instance" "instance" {
  name = "bt-instance-${local.name_suffix}"
  cluster {
    cluster_id   = "bt-instance-${local.name_suffix}"
    zone         = "us-central1-b"
    num_nodes    = 3
    storage_type = "HDD"
  }
}

resource "google_bigtable_app_profile" "ap" {
  instance       = google_bigtable_instance.instance.name
  app_profile_id = "bt-profile-${local.name_suffix}"

  single_cluster_routing {
    cluster_id                 = "bt-instance-${local.name_suffix}"
    allow_transactional_writes = true
  }

  ignore_warnings = true
}
