resource "google_oracle_database_odb_network" "my-odbnetwork"{
  odb_network_id = "my-odbnetwork-${local.name_suffix}"
  location = "us-west3"
  project = "my-project-${local.name_suffix}"
  network = data.google_compute_network.default.id
  labels = {
    terraform_created = "true"
  }
  deletion_protection = "true-${local.name_suffix}"
}

data "google_compute_network" "default" {
  name     = "new"
  project = "my-project-${local.name_suffix}"
}
