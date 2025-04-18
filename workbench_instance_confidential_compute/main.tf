resource "google_workbench_instance" "instance" {
  name = "workbench-instance-${local.name_suffix}"
  location = "us-central1-a"

  gce_setup {
    machine_type = "n2d-standard-2" // cant be e2 because of accelerator

    shielded_instance_config {
      enable_secure_boot = true
      enable_vtpm = true
      enable_integrity_monitoring = true
    }

    metadata = {
      terraform = "true"
    }

    confidential_instance_config {
      confidential_instance_type = "SEV"
    }

  }
}
