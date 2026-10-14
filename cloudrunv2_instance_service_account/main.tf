resource "google_cloud_run_v2_instance" "default" {
  name                = "cloudrun-instance-${local.name_suffix}"
  location            = "us-east4"
  service_account     = google_service_account.service_account.email

  containers {
    image = "us-docker.pkg.dev/cloudrun/container/hello"
  }
}

resource "google_service_account" "service_account" {
  account_id   = "test-sa-${local.name_suffix}"
  display_name = "Test Service Account"
}
