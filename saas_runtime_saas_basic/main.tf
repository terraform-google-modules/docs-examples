resource "google_saas_runtime_saas" "example" {
  saas_id  = "test-saas-${local.name_suffix}"
  location = "global"

  locations {
    name = "us-central1"
  }
  locations {
    name = "europe-west1"
  }
}
