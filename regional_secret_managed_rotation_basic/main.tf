data "google_project" "project" {}

resource "google_sql_database_instance" "instance" {
  name             = "tf-sql-instance-${local.name_suffix}"
  region           = "us-central1"
  database_version = "POSTGRES_15"
  settings {
    tier    = "db-custom-1-3840"
    edition = "ENTERPRISE"
  }
  deletion_protection = false
}

resource "google_sql_user" "user" {
  name     = "tf-sql-user-${local.name_suffix}"
  instance = google_sql_database_instance.instance.name
  password = "initial-password"
}

resource "google_secret_manager_regional_secret" "secret" {
  secret_id   = "tf-reg-secret-${local.name_suffix}"
  location    = "us-central1"
  secret_type = "CLOUD_SQL_DB_CREDENTIALS"
}

# Grant the regional secret's principal the Cloud SQL permissions required for managed rotation.
resource "google_project_iam_member" "secret_cloudsql_access" {
  project = data.google_project.project.project_id
  role    = "roles/cloudsql.admin"
  member  = google_secret_manager_regional_secret.secret.policy_member[0].iam_policy_uid_principal
}

resource "google_secret_manager_regional_secret_managed_rotation" "rotation" {
  secret_id = google_secret_manager_regional_secret.secret.secret_id
  location  = google_secret_manager_regional_secret.secret.location

  cloud_sql_single_user_credentials {
    instance_id = google_sql_database_instance.instance.name
    username    = google_sql_user.user.name
    password    = "initial-password"
  }

  depends_on = [google_project_iam_member.secret_cloudsql_access]
}
