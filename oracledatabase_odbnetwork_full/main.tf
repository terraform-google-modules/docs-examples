resource "google_oracle_database_odb_network" "my-odbnetwork"{
  odb_network_id = "my-odbnetwork-${local.name_suffix}"
  location = "us-west3"
  project = "my-project-${local.name_suffix}"
  network = data.google_compute_network.default.id
  gcp_oracle_zone = "us-west3-a-r1"
  labels = {
    terraform_created = "true"
  }
  service_connectivity_config {
    psc_interface_config {
      network_attachment = google_compute_network_attachment.default.id
    }
  }
  deletion_protection = "true-${local.name_suffix}"
}

data "google_compute_network" "default" {
  name     = "new"
  project = "my-project-${local.name_suffix}"
}

resource "google_compute_network_attachment" "default" {
  name                  = "my-attachment-${local.name_suffix}"
  region                = "us-west3"
  project               = "my-project-${local.name_suffix}"
  description           = "basic network attachment description"
  connection_preference = "ACCEPT_AUTOMATIC"

  subnetworks = [
    google_compute_subnetwork.default.self_link
  ]
}

resource "google_compute_subnetwork" "default" {
  name          = "my-subnet-${local.name_suffix}"
  region        = "us-west3"
  project       = "my-project-${local.name_suffix}"
  network       = data.google_compute_network.default.id
  ip_cidr_range = "10.1.0.0/16"
}
