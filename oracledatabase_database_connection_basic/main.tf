data "google_project" "project" {
  project_id = "my-project-${local.name_suffix}"
}

resource "google_oracle_database_autonomous_database" "target" {
  autonomous_database_id = "my-adb-${local.name_suffix}"
  location               = "us-east4"
  project                = "my-project-${local.name_suffix}"
  database               = "mydatabase-${local.name_suffix}"
  admin_password         = "123Abpassword"
  odb_network            = "projects/my-project/locations/us-east4/odbNetworks/my-odbnetwork-${local.name_suffix}"
  odb_subnet             = "projects/my-project/locations/us-east4/odbNetworks/my-odbnetwork/odbSubnets/my-odbsubnet-${local.name_suffix}"
  properties {
    compute_count            = "2"
    data_storage_size_tb     = "1"
    db_version               = "19c"
    db_workload              = "OLTP"
    license_type             = "LICENSE_INCLUDED"
    mtls_connection_required = "false"
  }
  deletion_protection = true-${local.name_suffix}
}

resource "google_secret_manager_secret" "password" {
  project   = "my-project-${local.name_suffix}"
  secret_id = "my-password-secret-${local.name_suffix}"
  replication {
    user_managed {
      replicas {
        location = "us-east4"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "password" {
  secret      = google_secret_manager_secret.password.id
  secret_data = "123Abpassword"
}

resource "google_secret_manager_secret_iam_member" "password_accessor" {
  project   = google_secret_manager_secret.password.project
  secret_id = google_secret_manager_secret.password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-oci.iam.gserviceaccount.com"
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"

  depends_on = [google_secret_manager_secret_iam_member.password_accessor]
}

resource "google_oracle_database_database_connection" "default" {
  database_connection_id  = "my-connection-${local.name_suffix}"
  location                = "us-east4"
  project                 = "my-project-${local.name_suffix}"
  connection_string       = "(description=(address=(protocol=tcps)(port=1521)(host=${google_oracle_database_autonomous_database.target.properties[0].private_endpoint_ip}))(connect_data=(service_name=${split("/", google_oracle_database_autonomous_database.target.properties[0].connection_strings[0].high)[1]}))(security=(ssl_server_dn_match=yes)(ssl_server_cert_dn=\"CN=${google_oracle_database_autonomous_database.target.properties[0].private_endpoint}\")))"
  username                = "ADMIN"
  password_secret_version = "projects/my-project-${local.name_suffix}/secrets/${google_secret_manager_secret.password.secret_id}/versions/${google_secret_manager_secret_version.password.version}"
  odb_network             = "projects/my-project/locations/us-east4/odbNetworks/my-odbnetwork-${local.name_suffix}"

  depends_on = [time_sleep.wait_60_seconds]
}
