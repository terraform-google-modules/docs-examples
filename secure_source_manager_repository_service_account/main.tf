resource "google_secure_source_manager_instance" "instance" {
  location = "us-central1"
  instance_id = "my-instance-${local.name_suffix}"
  deletion_policy = ""DELETE""
}

resource "google_service_account" "sa" {
  account_id   = "my-sa-${local.name_suffix}"
  display_name = "Test Service Account"
}

resource "google_secure_source_manager_repository" "default" {
  location = "us-central1"
  repository_id = "my-repository-${local.name_suffix}"
  instance = google_secure_source_manager_instance.instance.name
  deletion_policy = ""DELETE""

  service_account = google_service_account.sa.email
}
