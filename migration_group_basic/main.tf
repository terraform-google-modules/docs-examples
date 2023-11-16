resource "google_migration_center_group" "default" {
  location     = "us-central1"
  group_id     = "group-test-${local.name_suffix}"
  description  = "Terraform integration test description"
  display_name = "Terraform integration test display"
  labels       = {
    key = "value"
  }
}
