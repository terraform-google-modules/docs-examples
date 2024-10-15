resource "google_compute_region_backend_service" "default" {
  name                            = "region-service-${local.name_suffix}"
  region                          = "us-central1"
  health_checks                   = [google_compute_region_health_check.health_check.id]

  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTP"
  ip_address_selection_policy = "IPV6_ONLY"
}

resource "google_compute_region_health_check" "health_check" {
  name               = "rbs-health-check-${local.name_suffix}"
  region             = "us-central1"

  tcp_health_check {
    port = 80
  }
}
