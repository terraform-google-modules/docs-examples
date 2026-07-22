resource "google_vertex_ai_persistent_resource" "persistent_resource" {
  name         = "example-persistent-resource-${local.name_suffix}"
  location     = "us-central1"
  display_name = "Example persistent resource"

  resource_pools {
    machine_spec {
      machine_type = "n1-standard-4"
    }

    replica_count = 1
  }
}
