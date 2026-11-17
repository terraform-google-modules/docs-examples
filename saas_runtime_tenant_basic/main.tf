resource "google_saas_runtime_saas" "example_saas" {
  saas_id  = "example-saas-${local.name_suffix}"
  location = "global"

  locations {
    name = "us-central1"
  }
}

resource "google_saas_runtime_tenant" "example" {
  location = "global"
  tenant_id = "example-tenant-${local.name_suffix}"
  saas = google_saas_runtime_saas.example_saas.id
  consumer_resource = "//compute.googleapis.com/projects/example-project/zones/us-central1-a/instances/example-instance"
}
