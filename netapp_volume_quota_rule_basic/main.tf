resource "google_netapp_storage_pool" "default" {
  name = "test-pool-${local.name_suffix}"
  location = "us-west2"
  service_level = "PREMIUM"
  capacity_gib = 2048
  network = data.google_compute_network.default.id
}

resource "google_netapp_volume" "default" {
  location = google_netapp_storage_pool.default.location
  name = "test-volume-${local.name_suffix}"
  capacity_gib = 100
  share_name = "test-volume-${local.name_suffix}"
  storage_pool = google_netapp_storage_pool.default.name
  protocols = ["NFSV3"]
}

resource "google_netapp_volume_quota_rule" "test_quota_rule" {
  depends_on = [google_netapp_volume.default]
  location = google_netapp_volume.default.location
  volume_name = google_netapp_volume.default.name
  type = "DEFAULT_USER_QUOTA"
  disk_limit_mib = 50
  name = "test-volume-quota-rule-${local.name_suffix}"
}

data "google_compute_network" "default" {
  name = "test-network-${local.name_suffix}"
}
