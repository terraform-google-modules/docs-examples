resource "google_compute_network" "default" {
  name = "rbs-net-${local.name_suffix}"
}

resource "google_compute_region_backend_service" "default" {
  region                          = "us-central1"
  name                            = "region-service-${local.name_suffix}"
  protocol                        = "UDP"
  load_balancing_scheme           = "EXTERNAL"
  network                         = google_compute_network.default.id
  ha_policy  {
    fast_ip_move                  = "GARP_RA"
  }
  // Must explicitly disable connection draining to override default value.
  connection_draining_timeout_sec = 0
}
