resource "google_network_connectivity_multicloud_data_transfer_config" "config" {
  name        = "basic-config-${local.name_suffix}"
  location    = "europe-west4"
  description = "A basic multicloud data transfer config for the destination example"
}

resource "google_network_connectivity_destination" "example" {
  name        = "basic-destination-${local.name_suffix}"
  location    = "europe-west4"
  multicloud_data_transfer_config = google_network_connectivity_multicloud_data_transfer_config.config.name
  description = "A basic destination"
  labels = {
    foo = "bar"
  }
  ip_prefix   = "10.0.0.0/8"
  endpoints {
    asn = "14618"
    csp = "AWS"
  }
}
