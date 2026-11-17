data "google_compute_network" "default" {
  name = "test-network-bpa-${local.name_suffix}"
}

resource "google_netapp_storage_pool" "default" {
  name = "test-pool-bpa-${local.name_suffix}"
  location = "us-central1-a"
  service_level = "FLEX"
  type = "UNIFIED"
  capacity_gib = "1024"
  network = data.google_compute_network.default.id
}

resource "google_netapp_volume" "my_volume" {
  location = "us-central1-a"
  name = "test-volume-bpa-${local.name_suffix}"
  capacity_gib = "100"
  share_name = "test-volume-bpa-${local.name_suffix}"
  storage_pool = google_netapp_storage_pool.default.name
  protocols = ["NFSV3"]
  deletion_policy = "FORCE"
}

resource "google_backup_dr_backup_vault" "my_backup_vault" {
  location = "us-central1"
  backup_vault_id = "bv-bpa-netapp-${local.name_suffix}"
  backup_minimum_enforced_retention_duration = "100000s"
  force_delete = true
}

resource "google_backup_dr_backup_plan" "my_backup_plan" {
  location = "us-central1"
  backup_plan_id = "bp-bpa-netapp-${local.name_suffix}"
  resource_type = "netapp.googleapis.com/Volume"
  backup_vault = google_backup_dr_backup_vault.my_backup_vault.id

  backup_rules {
    rule_id = "rule-1"
    backup_retention_days = 5

    standard_schedule {
      recurrence_type = "HOURLY"
      hourly_frequency = 6
      time_zone = "UTC"

      backup_window {
        start_hour_of_day = 0
        end_hour_of_day = 6
      }
    }
  }
}

resource "google_backup_dr_backup_plan_association" "my-backup-plan-association-netapp" {
  location = "us-central1"
  resource_type = "netapp.googleapis.com/Volume"
  backup_plan_association_id = "my-bpa-netapp-${local.name_suffix}"
  resource = google_netapp_volume.my_volume.id
  backup_plan = google_backup_dr_backup_plan.my_backup_plan.name
}
