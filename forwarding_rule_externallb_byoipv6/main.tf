// Forwarding rule for External Network Load Balancing using Backend Services with IP Collection

resource "google_compute_forwarding_rule" "default" {
  name                  = "byoipv6-forwarding-rule-${local.name_suffix}"
  region                = "us-central1"
  port_range            = 80
  ip_protocol           = "TCP"
  ip_version            = "IPV6"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = ""2600:1901:4457:1::/96"-${local.name_suffix}"
  network_tier          = "PREMIUM"
  backend_service       = google_compute_region_backend_service.backend.id
  ip_collection         = ""projects/tf-static-byoip/regions/us-central1/publicDelegatedPrefixes/tf-test-forwarding-rule-mode-pdp"-${local.name_suffix}"
}

resource "google_compute_region_backend_service" "backend" {
  name                  = "website-backend-${local.name_suffix}"
  region                = "us-central1"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.hc.id]
}

resource "google_compute_region_health_check" "hc" {
  name               = "website-backend-${local.name_suffix}"
  check_interval_sec = 1
  timeout_sec        = 1
  region             = "us-central1"

  tcp_health_check {
    port = "80"
  }
}
