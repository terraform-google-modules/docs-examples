resource "google_bigquery_capacity_commitment" "commitment" {
	location   = "us-west1"
	slot_count = 100
	plan       = "FLEX"
}

resource "time_sleep" "wait_61_seconds" {
	depends_on = [google_bigquery_capacity_commitment.commitment]
    
	# Only needed for CI tests to be able to tear down the commitment once it's expired
    create_duration = "61s"
}
