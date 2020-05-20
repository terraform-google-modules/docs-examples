resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret-${local.name_suffix}"
  
  labels = {
    label = "my-label"
  }

  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
      replicas {
        location = "us-east1"
      }
    }
  }
}
