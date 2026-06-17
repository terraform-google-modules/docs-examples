resource "google_vertex_ai_persistent_resource" "persistent_resource" {
  name = "persistent-resource-${local.name_suffix}"
  location = "us-central1"
  resource_pools {
    machine_spec {
      machine_type = "e2-standard-4"
    }
    replica_count = 1
    disk_spec {
      boot_disk_type = "pd-standard"
      boot_disk_size_gb = 100
    }
  }
}
