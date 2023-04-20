// Forwarding rule for VPC private service connect
resource "google_compute_forwarding_rule" "default" {
  provider              = google-beta
  name                  = "steering-rule-${local.name_suffix}"
  region                = "us-central1"
  ip_address            = google_compute_address.address.id
  backend_service       = google_compute_region_backend_service.backend_service.id
  network_tier = "PREMIUM"
  description = "A test steering forwarding rule"
  ip_protocol = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range = "80-81"
  source_ip_ranges = ["34.121.88.0/24", "35.187.239.137"]
  depends_on = [google_compute_forwarding_rule.external_forwarding_rule]
}

resource "google_compute_address" "address" {
  name         = "website-ip-${local.name_suffix}-1"
  provider     = google-beta
  region       = "us-central1"
}

resource "google_compute_forwarding_rule" "external_forwarding_rule" {
  provider = google-beta
  name     = "forwarding-rule-${local.name_suffix}"
  region                = "us-central1"
  ip_address            = google_compute_address.address.id
  backend_service       = google_compute_region_backend_service.backend_service.id
  network_tier = "PREMIUM"
  description = "A test steering forwarding rule"
  ip_protocol = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range = "80-81"
}

resource "google_compute_region_backend_service" "backend_service" {
  provider = google-beta
  name     = "service-backend-${local.name_suffix}"
  region   = "us-central1"

  load_balancing_scheme = "EXTERNAL"
}
