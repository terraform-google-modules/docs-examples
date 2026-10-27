resource "google_secret_manager_regional_secret" "regional-secret-cloud-sql-db-credentials" {
  secret_id   = "tf-reg-secret-${local.name_suffix}"
  location    = "us-central1"
  secret_type = "CLOUD_SQL_DB_CREDENTIALS"
}
