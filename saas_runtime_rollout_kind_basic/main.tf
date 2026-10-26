resource "google_saas_runtime_saas" "example_saas" {
  saas_id  = "example-saas-${local.name_suffix}"
  location = "global"

  locations {
    name = "us-central1"
  }
}

resource "google_saas_runtime_unit_kind" "example_unitkind" {
  location     = "global"
  unit_kind_id = "example-unitkind-${local.name_suffix}"
  saas         = google_saas_runtime_saas.example_saas.id
}

resource "google_saas_runtime_rollout_kind" "example" {
  location          = "global"
  rollout_kind_id   = "example-rolloutkind-${local.name_suffix}"
  unit_kind         = google_saas_runtime_unit_kind.example_unitkind.id

  rollout_orchestration_strategy = "Google.Cloud.Simple.OneLocationAtATime"
  error_budget {
    allowed_count = 1
  }
  unit_filter = "unit.labels['key1'] == 'value1'"
}
