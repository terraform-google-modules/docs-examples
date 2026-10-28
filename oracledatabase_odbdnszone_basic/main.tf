resource "google_oracle_database_odb_dns_zone" "my-odbdnszone"{
  odb_dns_zone_id = "my-odbdnszone-${local.name_suffix}"
  location = "europe-west2"
  project = "my-project-${local.name_suffix}"
  odbnetwork = "my-odbnetwork-${local.name_suffix}"
  domain = "example.com-${local.name_suffix}"
  labels = {
    terraform_created = "true"
  }
  deletion_protection = "true-${local.name_suffix}"
}
