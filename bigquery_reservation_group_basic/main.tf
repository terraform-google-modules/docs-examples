resource "google_bigquery_reservation_group" "reservation_group" {
  name     = "my-reservation-group-${local.name_suffix}"
  location = "us-west2"
}
