resource "google_data_fusion_instance" "psc_instance" {
  name             = "psc-instance-${local.name_suffix}"
  region           = "us-central1"
  type             = "BASIC"
  private_instance = true

  network_config {
    connection_type = "PRIVATE_SERVICE_CONNECT_INTERFACES"
    private_service_connect_config {
      network_attachment     = google_compute_network_attachment.psc.id
      unreachable_cidr_block = "192.168.0.0/25"
    }
  }

  -${local.name_suffix}
}

resource "google_compute_network" "psc" {
  name                    = "datafusion-psc-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "psc" {
  name   = "datafusion-psc-subnet-${local.name_suffix}"
  region = "us-central1"

  network       = google_compute_network.psc.id
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_network_attachment" "psc" {
  name                  = "datafusion-psc-attachment-${local.name_suffix}"
  region                = "us-central1"
  connection_preference = "ACCEPT_AUTOMATIC"

  subnetworks = [
    google_compute_subnetwork.psc.self_link
  ]
}
