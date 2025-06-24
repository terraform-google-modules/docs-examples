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

resource "google_compute_backend_service" "default" {
  name                  = "backend-service-${local.name_suffix}"
  health_checks = [google_compute_health_check.default.id]

  # WEIGHTED_ROUND_ROBIN and CUSTOM_METRICS require EXTERNAL_MANAGED.
  load_balancing_scheme = "EXTERNAL_MANAGED"
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
  log_config {
    enable          = true
    optional_mode   = "CUSTOM"
    optional_fields = [ "orca_load_report", "tls.protocol" ]
  }  
}

resource "google_compute_health_check" "default" {
  name               = "health-check-${local.name_suffix}"
  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}
