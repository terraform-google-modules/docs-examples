resource "google_saas_runtime_saas" "example_saas_regional" {
  saas_id  = "example-saas-${local.name_suffix}"
  location = "us-central1"

  locations {
    name = "us-central1"
  }
}

resource "google_saas_runtime_unit_kind" "example_unit_kind" {
  location = "us-central1"
  unit_kind_id = "example-unitkind-${local.name_suffix}"
  saas = google_saas_runtime_saas.example_saas_regional.id
}

resource "google_saas_runtime_unit" "example" {
  location = "us-central1"
  unit_id = "example-unit-${local.name_suffix}"
  unit_kind = google_saas_runtime_unit_kind.example_unit_kind.id
  management_mode = "MANAGEMENT_MODE_USER"
}
