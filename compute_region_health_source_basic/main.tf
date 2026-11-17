resource "google_compute_region_health_aggregation_policy" "hap" {
  name        = "test-health-source-${local.name_suffix}-hap"
  description = "health aggregation policy for health source"
  region      = "us-central1"
}

resource "google_compute_health_check" "default" {
  name     = "test-health-source-${local.name_suffix}-hc"
  http_health_check {
    port = 80
  }
}

resource "google_compute_region_backend_service" "default" {
  name                  = "test-health-source-${local.name_suffix}-bs"
  region                = "us-central1"
  health_checks         = [google_compute_health_check.default.id]
  load_balancing_scheme = "INTERNAL"
}

resource "google_compute_region_health_source" "example_test_health_source" {
  name                      = "test-health-source-${local.name_suffix}"
  description               = "Example health source basic-${local.name_suffix}"
  region                    = "us-central1"
  source_type               = "BACKEND_SERVICE"
  sources                   = [google_compute_region_backend_service.default.id]
  health_aggregation_policy = google_compute_region_health_aggregation_policy.hap.id
}
