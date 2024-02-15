resource "google_migration_center_preference_set" "default" {
  location          = "us-central1"
  preference_set_id = "preference-set-test-${local.name_suffix}"
  description       = "Terraform integration test description"
  display_name      = "Terraform integration test display"
  virtual_machine_preferences {
    vmware_engine_preferences {
      cpu_overcommit_ratio = 1.5
    }
    sizing_optimization_strategy = "SIZING_OPTIMIZATION_STRATEGY_SAME_AS_SOURCE"
    target_product = "COMPUTE_MIGRATION_TARGET_PRODUCT_COMPUTE_ENGINE"
  }
}
