resource "google_compute_instance" "instance" {
  name         = "my-instance-${local.name_suffix}"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
  
  lifecycle {
    ignore_changes = [resource_policies]
  }
}

resource "google_compute_resource_policy" "policy" {
  name   = "my-resource-policy-${local.name_suffix}"
  region = "us-central1"
  
  instance_schedule_policy {
    vm_start_schedule {
      schedule = "0 8 * * *"
    }
    
    vm_stop_schedule {
      schedule = "0 18 * * *"
    }
    
    time_zone = "America/New_York"
  }
}

resource "google_compute_resource_policy_attachment" "attachment" {
  name     = google_compute_resource_policy.policy.name
  instance = google_compute_instance.instance.name
  zone     = "us-central1-a"
}
