resource "google_network_connectivity_multicloud_data_transfer_config" "example" {
  name        = "basic_config-${local.name_suffix}"
  location = "europe-west1"
  description = "A basic multicloud data transfer configs"
  labels = {
    foo = "bar"
  }
  services {
    service_name = "big-query"
  }
  services {
    service_name = "cloud-storage"
  }
}
