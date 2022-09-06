resource "google_datastream_connection_profile" "default" {
	display_name          = "Connection profile"
	location              = "us-central1"
	connection_profile_id = "my-profile-${local.name_suffix}"

	gcs_profile {
		bucket    = "my-bucket"
		root_path = "/path"
	}
}
