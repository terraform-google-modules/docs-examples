data "google_compute_network" "default" {
  name = ""
}

resource "google_netapp_storage_pool" "default" {
  name = "backup-pool-${local.name_suffix}"
  location = "us-central1"
  service_level = "PREMIUM"
  capacity_gib = "2048"
  network = data.google_compute_network.default.id
}

resource "google_netapp_volume" "default" {
  name = "backup-volume-${local.name_suffix}"
  location = google_netapp_storage_pool.default.location
  capacity_gib = "100"
  share_name = "backup-volume-${local.name_suffix}"
  storage_pool = google_netapp_storage_pool.default.name
  protocols = ["NFSV3"]
  deletion_policy = "FORCE"
  backup_config {
    backup_vault = google_netapp_backup_vault.default.id
  }
}

resource "google_netapp_backup_vault" "default" {
  name = "backup-vault-${local.name_suffix}"
  location = google_netapp_storage_pool.default.location
}

resource "google_netapp_backup" "test_backup" {
  name = "test-backup-${local.name_suffix}"
  location = google_netapp_backup_vault.default.location
  vault_name = google_netapp_backup_vault.default.name
  source_volume = google_netapp_volume.default.id
}
