resource "google_oracle_database_odb_subnet" "my-odbsubnet"{
  odb_subnet_id = "my-odbsubnet-${local.name_suffix}"
  location = "europe-west2"
  project = "my-project-${local.name_suffix}"
  odbnetwork = "my-odbnetwork-${local.name_suffix}"
  cidr_range = "10.1.1.0/24"
  purpose = "CLIENT_SUBNET"
  labels = {
    terraform_created = "true"
  }
  deletion_protection = "true-${local.name_suffix}"
}
