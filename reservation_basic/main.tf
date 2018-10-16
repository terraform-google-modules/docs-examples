resource "google_compute_reservation" "gce_reservation" {
  name = "gce-reservation-${local.name_suffix}"
  zone = "us-central1-a"

  specific_reservation {
    count = 1
    instance_properties {
      min_cpu_platform = "Intel Cascade Lake"
      machine_type     = "n2-standard-2"
    }
  }
}
