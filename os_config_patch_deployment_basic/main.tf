resource "google_os_config_patch_deployment" "patch" {
  patch_deployment_id = "patch-deploy-inst-${local.name_suffix}"

  instance_filter {
    all = true
  }

  recurring_schedule {
    time_zone {
      id = "America/New_York"
    }

    time_of_day {
      hours = 1
    }

    weekly {
      day_of_week = "MONDAY"
    }
  }
}
