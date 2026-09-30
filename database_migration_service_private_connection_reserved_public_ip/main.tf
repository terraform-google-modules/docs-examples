resource "google_database_migration_service_private_connection" "default" {
	display_name          = "dbms_pc"
	location              = "us-west1"
	private_connection_id = "my-connection-${local.name_suffix}"

	labels = {
		key = "value"
	}

	reserved_public_ip_config {
		nat_ips_count = 1
	}

	create_without_validation = false
}
