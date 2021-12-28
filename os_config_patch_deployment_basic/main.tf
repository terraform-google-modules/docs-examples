resource "google_os_config_patch_deployment" "patch" {
  patch_deployment_id = "patch-deploy-${local.name_suffix}"

  instance_filter {
    all = true
  }

  one_time_schedule {
    execute_time = "2999-10-10T10:10:10.045123456Z"
  }
}
