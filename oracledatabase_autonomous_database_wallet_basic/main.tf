resource "google_oracle_database_autonomous_database" "myADB" {
  autonomous_database_id = "my-instance-${local.name_suffix}"
  location               = "us-east4"
  project                = "my-project-${local.name_suffix}"
  database               = "mydatabase-${local.name_suffix}"
  admin_password         = "123Abpassword"
  network                = data.google_compute_network.default.id
  cidr                   = "10.5.0.0/24"
  properties {
    compute_count        = "2"
    data_storage_size_tb = "1"
    db_version           = "19c"
    db_workload          = "OLTP"
    license_type         = "LICENSE_INCLUDED"
  }

  deletion_protection = "true-${local.name_suffix}"
}

data "google_compute_network" "default" {
  name    = "new"
  project = "my-project-${local.name_suffix}"
}

resource "google_oracle_database_autonomous_database_wallet" "myWallet" {
  autonomous_database = google_oracle_database_autonomous_database.myADB.id
  password_wo         = "123Abpassword"
  password_wo_version = 1
}

# A second wallet for the same database, using the non-write-only password argument.
resource "google_oracle_database_autonomous_database_wallet" "wallet_password" {
  autonomous_database = google_oracle_database_autonomous_database.myADB.id
  type                = "SINGLE"
  password            = "123Abpassword"
}
