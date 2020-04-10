resource "google_compute_global_network_endpoint_group" "neg" {
  name                  = "my-lb-neg-${local.name_suffix}"
  default_port          = "90"
  network_endpoint_type = "INTERNET_FQDN_PORT"
}
