resource "google_compute_region_instance_template" "a3_dws" {
  name                 = "a3-dws-${local.name_suffix}"
  region               = "us-central1"
  description          = "This template is used to create a mig instance that is compatible with DWS resize requests."
  instance_description = "A3 GPU"
  machine_type         = "a3-highgpu-8g"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = false
    on_host_maintenance = "TERMINATE"
  }

  disk {
    source_image = "cos-cloud/cos-121-lts"
    auto_delete  = true
    boot         = true
    disk_type    = "pd-ssd"
    disk_size_gb = "960"
    mode         = "READ_WRITE"
  }

  guest_accelerator {
    type  = "nvidia-h100-80gb"
    count = 8
  }

  reservation_affinity {
    type = "NO_RESERVATION"
  }

  shielded_instance_config {
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  network_interface {
    network = "default"
  }
}

resource "google_compute_instance_group_manager" "a3_dws" {
  name               = "a3-dws-${local.name_suffix}"
  base_instance_name = "a3-dws"
  zone               = "us-central1-a"

  version {
    instance_template = google_compute_region_instance_template.a3_dws.self_link
  }

  instance_lifecycle_policy {
    default_action_on_failure = "DO_NOTHING"
  }

  wait_for_instances = false

}

resource "google_compute_resize_request" "a3_resize_request" {
  name                   = "a3-dws-${local.name_suffix}"
  instance_group_manager = google_compute_instance_group_manager.a3_dws.name
  zone                   = "us-central1-a"
  description            = "Test resize request resource"
  resize_by              = 2
  requested_run_duration {
    seconds = 14400
    nanos   = 0
  }
}
