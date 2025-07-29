resource "google_oracle_database_autonomous_database" "myADB"{
  autonomous_database_id = "my-instance-${local.name_suffix}"
  location = "europe-west2"
  project = "my-project-${local.name_suffix}"
  database = "mydatabase-${local.name_suffix}"
  admin_password = "123Abpassword"
  properties {
    compute_count = "2"
    data_storage_size_tb="1"
    db_version = "19c"
    db_workload = "OLTP"
    license_type = "LICENSE_INCLUDED"
    mtls_connection_required = "true"
    }
  deletion_protection = "true-${local.name_suffix}"
}
