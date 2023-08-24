resource "google_bigquery_bi_reservation" "reservation" {
	location   = "us-west2"
	size   = "3000000000"
}
