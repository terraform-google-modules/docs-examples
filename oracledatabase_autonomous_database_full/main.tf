resource "google_oracle_database_autonomous_database" "myADB"{
  autonomous_database_id = "my-instance-${local.name_suffix}"
  location = "us-east4"
  project = "my-project-${local.name_suffix}"
  display_name = "autonomousDatabase displayname"
  database = "testdatabase"
  admin_password = "123Abpassword"
  network = data.google_compute_network.default.id
  cidr = "10.5.0.0/24"
  labels = {
    "label-one" = "value-one"
  }
  properties {
    compute_count         = "2"
    data_storage_size_gb   = "48"
    db_version = "19c"
    db_edition = "STANDARD_EDITION"
    db_workload = "OLTP"
    is_auto_scaling_enabled= "true"
    license_type = "BRING_YOUR_OWN_LICENSE"
    backup_retention_period_days    = "60"
    character_set                   = "AL32UTF8"
    is_storage_auto_scaling_enabled = "false"
    maintenance_schedule_type       = "REGULAR"
    mtls_connection_required        = "false"
    n_character_set                 = "AL16UTF16"
    operations_insights_state       = "NOT_ENABLED"
    customer_contacts {
      email = "xyz@example.com"
    }
    private_endpoint_ip    = "10.5.0.11"
    private_endpoint_label = "testhost"
  }
  deletion_protection = "true-${local.name_suffix}"
}

data "google_compute_network" "default" {
  name     = "new"
  project = "my-project-${local.name_suffix}"
}
