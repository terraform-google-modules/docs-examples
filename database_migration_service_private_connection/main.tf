resource "google_database_migration_service_private_connection" "default" {
	display_name          = "dbms_pc"
	location              = "us-central1"
	private_connection_id = "my-connection-${local.name_suffix}"

	labels = {
		key = "value"
	}

	vpc_peering_config {
		vpc_name = resource.google_compute_network.default.id
		subnet = "10.0.0.0/29"
	}

	create_without_validation = false
}

resource "google_compute_network" "default" {
  name = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}
