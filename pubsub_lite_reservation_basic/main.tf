resource "google_pubsub_lite_reservation" "example" {
  name = "example-reservation-${local.name_suffix}"
  project = data.google_project.project.number
  throughput_capacity = 2
}

data "google_project" "project" {
}
