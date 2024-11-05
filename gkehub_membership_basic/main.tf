resource "google_container_cluster" "primary" {
  name               = "basic-cluster-${local.name_suffix}"
  location           = "us-central1-a"
  initial_node_count = 1
  deletion_protection  = false
  network       = "default-${local.name_suffix}"
  subnetwork    = "default-${local.name_suffix}"
}

resource "google_gke_hub_membership" "membership" {
  membership_id = "basic-${local.name_suffix}"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.primary.id}"
    }
  }

  labels = {
    env = "test"
  }
}
