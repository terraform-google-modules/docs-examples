resource "google_compute_forwarding_rule" "steering" {
  name = "steering-rule-${local.name_suffix}"
  region = "us-central1"
  ip_address = google_compute_address.basic.address
  backend_service = google_compute_region_backend_service.external.self_link
  load_balancing_scheme = "EXTERNAL"
  source_ip_ranges = ["34.121.88.0/24", "35.187.239.137"]
  depends_on = [google_compute_forwarding_rule.external]
}

resource "google_compute_address" "basic" {
  name = "website-ip-${local.name_suffix}"
  region = "us-central1"
}

resource "google_compute_region_backend_service" "external" {
  name = "service-backend-${local.name_suffix}"
  region = "us-central1"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_forwarding_rule" "external" {
  name = "external-forwarding-rule-${local.name_suffix}"
  region = "us-central1"
  ip_address = google_compute_address.basic.address
  backend_service = google_compute_region_backend_service.external.self_link
  load_balancing_scheme = "EXTERNAL"
}
