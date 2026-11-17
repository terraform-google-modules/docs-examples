resource "google_compute_region_composite_health_check" "example_test_composite_health_check" {
  name               = "test-composite-health-check-${local.name_suffix}"
  description        = "test regional composite health check resource"
  region             = "us-central1"
  health_sources     = [google_compute_region_health_source.default.id]
  health_destination = google_compute_forwarding_rule.default.id
}

resource "google_compute_region_health_source" "default" {
  name                      = "test-composite-health-check-${local.name_suffix}-hs"
  region                    = "us-central1"
  source_type               = "BACKEND_SERVICE"
  sources                   = [google_compute_region_backend_service.default.id]
  health_aggregation_policy = google_compute_region_health_aggregation_policy.hap.id
}

resource "google_compute_region_health_aggregation_policy" "hap" {
  name        = "test-composite-health-check-${local.name_suffix}-hap"
  description = "health aggregation policy for health source"
  region      = "us-central1"
}

resource "google_compute_health_check" "default" {
  name     = "test-composite-health-check-${local.name_suffix}-hc"
  http_health_check {
    port = 80
  }
}

resource "google_compute_region_backend_service" "default" {
  name                  = "test-composite-health-check-${local.name_suffix}-bs"
  region                = "us-central1"
  health_checks         = [google_compute_health_check.default.id]
  load_balancing_scheme = "INTERNAL"
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "test-composite-health-check-${local.name_suffix}-fr"
  region                = "us-central1"
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.default.id
  network               = google_compute_network.default.id
  subnetwork            = google_compute_subnetwork.default.id
  ip_protocol           = "TCP"
  all_ports             = true
}

resource "google_compute_network" "default" {
  name                    = "test-composite-health-check-${local.name_suffix}-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "test-composite-health-check-${local.name_suffix}-sub"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.default.id
}
