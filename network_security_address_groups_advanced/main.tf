resource "google_network_security_address_group" "default" {
  provider    = google-beta
  name        = "my-address-groups-${local.name_suffix}"
  location    = "us-central1"
  description = "my description"
  type        = "IPV4"
  capacity    = "100"
  items       = ["208.80.154.224/32"]
}
