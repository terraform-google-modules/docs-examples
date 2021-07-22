resource "google_bigquery_reservation" "reservation" {
	name           = "my-reservation-${local.name_suffix}"
	location       = "asia-northeast1"
	// Set to 0 for testing purposes
	// In reality this would be larger than zero
	slot_capacity  = 0
	ignore_idle_slots = false
}
