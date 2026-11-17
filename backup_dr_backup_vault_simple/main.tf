resource "google_backup_dr_backup_vault" "backup-vault-test" {
  location = "us-central1"
  backup_vault_id    = "backup-vault-test-${local.name_suffix}"
  description = "This is a second backup vault built by Terraform."
  backup_minimum_enforced_retention_duration = "100000s"
  annotations = {
    annotations1 = "bar1"
    annotations2 = "baz1"
  }
  labels = {
    foo = "bar1"
    bar = "baz1"
  }
  force_update = "true"
  access_restriction = "WITHIN_ORGANIZATION"
  backup_retention_inheritance = "INHERIT_VAULT_RETENTION"
  ignore_inactive_datasources = "true"
  ignore_backup_plan_references = "true"
  allow_missing = "true"
}
