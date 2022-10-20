resource "google_datastream_private_connection" "private_connection" {
	display_name          = "Connection profile"
	location              = "us-central1"
	private_connection_id = "my-connection-${local.name_suffix}"

	labels = {
		key = "value"
	}

	vpc_peering_config {
		vpc = google_compute_network.default.id
		subnet = "10.0.0.0/29"
	}
}

resource "google_compute_network" "default" {
	name = "my-network-${local.name_suffix}"
}

resource "google_datastream_connection_profile" "default" {
	display_name          = "Connection profile"
	location              = "us-central1"
	connection_profile_id = "my-profile-${local.name_suffix}"

	bigquery_profile {}

	private_connectivity {
		private_connection = google_datastream_private_connection.private_connection.id
	}
}
