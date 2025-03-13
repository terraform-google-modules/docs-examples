resource "google_compute_network" "default" {
  name                    = "network-${local.name_suffix}"
}

// Zonal NEG with GCE_VM_IP_PORT
resource "google_compute_network_endpoint_group" "default" {
  name                  = "network-endpoint-${local.name_suffix}"
  network               = google_compute_network.default.id
  default_port          = "90"
  zone                  = "us-central1-a"
  network_endpoint_type = "GCE_VM_IP_PORT"
}

resource "google_compute_region_backend_service" "default" {
  region = "us-central1"
  name = "region-service-${local.name_suffix}"
  health_checks = [google_compute_health_check.health_check.id]
  load_balancing_scheme = "INTERNAL_MANAGED"
  locality_lb_policy    = "WEIGHTED_ROUND_ROBIN"
  custom_metrics {
    name    = "orca.application_utilization"
    # At least one metric should be not dry_run.
    dry_run = false
  }
  backend {
    group = google_compute_network_endpoint_group.default.id
    balancing_mode = "CUSTOM_METRICS"
    custom_metrics {
      name    = "orca.cpu_utilization"
      max_utilization = 0.9
      dry_run = true
    }
    custom_metrics {
      name    = "orca.named_metrics.foo"
      # At least one metric should be not dry_run.
      dry_run = false
    }
  }
}

resource "google_compute_health_check" "health_check" {
  name               = "rbs-health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
