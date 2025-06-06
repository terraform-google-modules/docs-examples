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

resource "google_managed_kafka_acl" "example" {
  acl_id = "topic/mytopic-${local.name_suffix}"
  cluster = google_managed_kafka_cluster.cluster.cluster_id
  location = "us-central1"
    acl_entries {
      principal = "User:admin@my-project.iam.gserviceaccount.com"
      permission_type = "ALLOW"
      operation = "ALL"
      host = "*"
    }
    acl_entries {
      principal = "User:producer-client@my-project.iam.gserviceaccount.com"
      permission_type = "ALLOW"
      operation = "WRITE"
      host = "*"
    }
}

data "google_project" "project" {
}
