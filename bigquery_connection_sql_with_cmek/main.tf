resource "google_sql_database_instance" "instance" {
  name             = "my-database-instance-${local.name_suffix}"
  region           = "us-central1"

  database_version = "POSTGRES_11"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection  = "false"
}

resource "google_sql_database" "db" {
  instance = google_sql_database_instance.instance.name
  name     = "db"
}

resource "google_sql_user" "user" {
  name = "user-${local.name_suffix}"
  instance = google_sql_database_instance.instance.name
  password = "tf-test-my-password%{random_suffix}"
}

data "google_bigquery_default_service_account" "bq_sa" {}

resource "google_kms_crypto_key_iam_member" "key_sa_user" {
  crypto_key_id = "projects/project/locations/us-central1/keyRings/us-central1/cryptoKeys/bq-key-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${data.google_bigquery_default_service_account.bq_sa.email}"
}

resource "google_bigquery_connection" "bq-connection-cmek" {
  friendly_name = "👋"
  description   = "a riveting description"
  location      = "US"
  kms_key_name  = "projects/project/locations/us-central1/keyRings/us-central1/cryptoKeys/bq-key-${local.name_suffix}"
  cloud_sql {
    instance_id = google_sql_database_instance.instance.connection_name
    database    = google_sql_database.db.name
    type        = "POSTGRES"
    credential {
      username = google_sql_user.user.name
      password = google_sql_user.user.password
    }
  }

  depends_on = [google_kms_crypto_key_iam_member.key_sa_user]
}
