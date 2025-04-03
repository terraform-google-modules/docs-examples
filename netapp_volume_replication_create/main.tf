
data "google_compute_network" "default" {
  name = "test-network-${local.name_suffix}"
}

resource "google_netapp_storage_pool" "source_pool" {
  name          = "source-pool-${local.name_suffix}"
  location      = "us-central1"
  service_level = "PREMIUM"
  capacity_gib  = 2048
  network       = data.google_compute_network.default.id
}

resource "google_netapp_storage_pool" "destination_pool" {
  name          = "destination-pool-${local.name_suffix}"
  location      = "us-west2"
  service_level = "PREMIUM"
  capacity_gib  = 2048
  network       = data.google_compute_network.default.id
  allow_auto_tiering = true
}

resource "google_netapp_volume" "source_volume" {
  location     = google_netapp_storage_pool.source_pool.location
  name         = "source-volume-${local.name_suffix}"
  capacity_gib = 100
  share_name   = "source-volume-${local.name_suffix}"
  storage_pool = google_netapp_storage_pool.source_pool.name
  protocols = [
    "NFSV3"
  ]
  deletion_policy = "FORCE"
}

resource "google_netapp_volume_replication" "test_replication" {
  depends_on           = [google_netapp_volume.source_volume]
  location             = google_netapp_volume.source_volume.location
  volume_name          = google_netapp_volume.source_volume.name
  name                 = "test-replication-${local.name_suffix}"
  replication_schedule = "EVERY_10_MINUTES"
  description          = "This is a replication resource"
  destination_volume_parameters {
    storage_pool = google_netapp_storage_pool.destination_pool.id
    volume_id    = "destination-volume-${local.name_suffix}"
    # Keeping the share_name of source and destination the same
    # simplifies implementing client failover concepts
    share_name  = "source-volume-${local.name_suffix}"
    description = "This is a replicated volume"
    tiering_policy {
        cooling_threshold_days = 20
        tier_action = "ENABLED"
    }
  }
  # WARNING: Setting delete_destination_volume to true, will delete the
  # CURRENT destination volume if the replication is deleted. Omit the field 
  # or set delete_destination_volume=false to avoid accidental volume deletion.
  delete_destination_volume = true
  wait_for_mirror = true
}
