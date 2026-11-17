data "google_project" "project" {
}

resource "google_compute_cross_site_network" "example-cross-site-network" {
  name                 = "test-cross-site-network-${local.name_suffix}"
  description         = "Example cross site network-${local.name_suffix}"
}
