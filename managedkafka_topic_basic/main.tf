resource "google_managed_kafka_cluster" "cluster" {
  cluster_id = "my-cluster-${local.name_suffix}"
  location = "us-central1"
  capacity_config {
    vcpu_count = 3
    memory_bytes = 3221225472
  }
  gcp_config {
    access_config {
      network_configs {
        subnet = "projects/${data.google_project.project.number}/regions/us-central1/subnetworks/default"
      }
    }
  }
}

resource "google_managed_kafka_topic" "example" {
  topic_id = "my-topic-${local.name_suffix}"
  cluster = google_managed_kafka_cluster.cluster.cluster_id
  location = "us-central1"
  partition_count = 2
  replication_factor = 3
  configs = {
    "cleanup.policy" = "compact"
  }
}

data "google_project" "project" {
}
