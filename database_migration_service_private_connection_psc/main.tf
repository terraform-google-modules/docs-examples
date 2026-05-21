resource "google_database_migration_service_private_connection" "default" {
	display_name          = "dbms_pc"
	location              = "us-west1"
	private_connection_id = "my-connection-${local.name_suffix}"

	labels = {
		key = "value"
	}

	psc_interface_config {
		network_attachment = resource.google_compute_network_attachment.default.id
	}

	create_without_validation = false
}

resource "google_compute_network_attachment" "default" {
  name                  = "my-attachment-${local.name_suffix}"
  region                = "us-west1"
  connection_preference = "ACCEPT_AUTOMATIC"
  subnetworks           = [resource.google_compute_subnetwork.default.id]
}

resource "google_compute_network" "default" {
  name = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "my-subnetwork-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-west1"
  network       = google_compute_network.default.id
}
