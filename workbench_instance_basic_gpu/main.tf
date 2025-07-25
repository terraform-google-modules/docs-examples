resource "google_compute_reservation" "gpu_reservation" {
  name     = "wbi-reservation-${local.name_suffix}"
  zone     = "us-central1-a"

  specific_reservation {
    count = 1
    
    instance_properties {
      machine_type = "n1-standard-1"
      
      guest_accelerators {
        accelerator_type  = "nvidia-tesla-t4"
        accelerator_count = 1
      }
    }
  }

  specific_reservation_required = false
}

resource "google_workbench_instance" "instance" {
  name = "workbench-instance-${local.name_suffix}"
  location = "us-central1-a"
  gce_setup {
    machine_type = "n1-standard-1" // cant be e2 because of accelerator
    accelerator_configs {
      type         = "NVIDIA_TESLA_T4"
      core_count   = 1
    }
    vm_image {
      project      = "cloud-notebooks-managed"
      family       = "workbench-instances"
    }
    reservation_affinity {
      consume_reservation_type = "RESERVATION_ANY"
    }
  }

  depends_on = [
    google_compute_reservation.gpu_reservation
  ]

}
