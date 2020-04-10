resource "google_compute_global_network_endpoint_group" "neg" {
  name                  = "my-lb-neg-${local.name_suffix}"
  network_endpoint_type = "INTERNET_IP_PORT"
  default_port          = 90
}
