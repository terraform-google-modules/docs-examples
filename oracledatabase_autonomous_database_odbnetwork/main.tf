resource "google_oracle_database_autonomous_database" "myADB"{
  autonomous_database_id = "my-instance-${local.name_suffix}"
  location = "europe-west2"
  project = "my-project-${local.name_suffix}"
  database = "mydatabase-${local.name_suffix}"
  admin_password = "123Abpassword"
  odb_network = "projects/my-project/locations/europe-west2/odbNetworks/my-odbnetwork-${local.name_suffix}"
  odb_subnet = "projects/my-project/locations/europe-west2/odbNetworks/my-odbnetwork/odbSubnets/my-odbsubnet-${local.name_suffix}"
  properties {
    compute_count = "2"
    data_storage_size_tb="1"
    db_version = "19c"
    db_workload = "OLTP"
    license_type = "LICENSE_INCLUDED"
    }
  deletion_protection = "true-${local.name_suffix}"
}
