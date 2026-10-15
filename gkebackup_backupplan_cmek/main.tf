resource "google_gke_backup_backup_plan" "cmek" {
  name = "cmek-plan-${local.name_suffix}"
  cluster = "projects/my-project-name/locations/us-east1/clusters/cmek-cluster-${local.name_suffix}"
  location = "us-east1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    selected_namespaces {
      namespaces = ["default", "test"]
    }
    encryption_key {
      gcp_kms_encryption_key = google_kms_crypto_key.crypto_key.id
    }
  }
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "backup-key-${local.name_suffix}"
  key_ring = google_kms_key_ring.key_ring.id
}

resource "google_kms_key_ring" "key_ring" {
  name     = "backup-key-${local.name_suffix}"
  location = "us-east1"
}
