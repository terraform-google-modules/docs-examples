resource "google_netapp_storage_pool" "default" {
  name = "test-pool-${local.name_suffix}"
  location = "us-west2"
  service_level = "PREMIUM"
  capacity_gib = "2048"
  network = data.google_compute_network.default.id
}

resource "google_netapp_volume" "test_volume" {
  location = "us-west2"
  name = "test-volume-${local.name_suffix}"
  capacity_gib = "100"
  share_name = "test-volume-${local.name_suffix}"
  storage_pool = google_netapp_storage_pool.default.name
  protocols = ["NFSV3"]
}

data "google_compute_network" "default" {
  name = "test-network-${local.name_suffix}"
}
