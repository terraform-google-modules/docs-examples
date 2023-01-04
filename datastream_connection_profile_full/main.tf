resource "google_datastream_connection_profile" "default" {
	display_name          = "Connection profile"
	location              = "us-central1"
	connection_profile_id = "my-profile-${local.name_suffix}"

	gcs_profile {
		bucket    = "my-bucket"
		root_path = "/path"
	}

	forward_ssh_connectivity {
		hostname = "google.com"
		username = "my-user"
		port     = 8022
		password = "swordfish"
	}
	labels = {
		key = "value"
	}
}
