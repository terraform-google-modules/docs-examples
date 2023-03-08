resource "google_data_fusion_instance" "extended_instance" {
  name                          = "my-instance-${local.name_suffix}"
  description                   = "My Data Fusion instance"
  display_name                  = "My Data Fusion instance"
  region                        = "us-central1"
  type                          = "BASIC"
  enable_stackdriver_logging    = true
  enable_stackdriver_monitoring = true
  private_instance              = true
  dataproc_service_account      = data.google_app_engine_default_service_account.default.email

  labels = {
    example_key = "example_value"
  }

  network_config {
    network       = "default"
    ip_allocation = "${google_compute_global_address.private_ip_alloc.address}/${google_compute_global_address.private_ip_alloc.prefix_length}"
  }

  accelerators {
    accelerator_type = "CDC"
    state = "ENABLED"
  }
  -${local.name_suffix}
}

data "google_app_engine_default_service_account" "default" {
}

resource "google_compute_network" "network" {
  name = "datafusion-full-network-${local.name_suffix}"
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "datafusion-ip-alloc-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 22
  network       = google_compute_network.network.id
}
