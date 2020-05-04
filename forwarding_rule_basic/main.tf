resource "google_compute_forwarding_rule" "default" {
  name       = "website-forwarding-rule-${local.name_suffix}"
  target     = google_compute_target_pool.default.id
  port_range = "80"
}

resource "google_compute_target_pool" "default" {
  name = "website-target-pool-${local.name_suffix}"
}
