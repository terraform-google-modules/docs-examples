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

resource "google_sql_database_instance" "instance" {
    name             = "my-instance-${local.name_suffix}"
    database_version = "POSTGRES_14"
    region           = "us-central1"
    settings {
        tier = "db-f1-micro"

        ip_configuration {

            // Datastream IPs will vary by region.
            authorized_networks {
                value = "34.71.242.81"
            }

            authorized_networks {
                value = "34.72.28.29"
            }

            authorized_networks {
                value = "34.67.6.157"
            }

            authorized_networks {
                value = "34.67.234.134"
            }

            authorized_networks {
                value = "34.72.239.218"
            }
        }
    }

    deletion_protection  = false
}

resource "google_sql_database" "db" {
    instance = google_sql_database_instance.instance.name
    name     = "db"
}

resource "random_password" "pwd" {
    length = 16
    special = false
}

resource "google_sql_user" "user" {
    name = "user"
    instance = google_sql_database_instance.instance.name
    password = random_password.pwd.result
}

resource "google_datastream_connection_profile" "default" {
	display_name          = "Connection profile"
	location              = "us-central1"
	connection_profile_id = "my-profile-${local.name_suffix}"

	postgresql_profile {
	    hostname = google_sql_database_instance.instance.public_ip_address
      username = google_sql_user.user.name
      password = google_sql_user.user.password
      database = google_sql_database.db.name
	}

	private_connectivity {
		private_connection = google_datastream_private_connection.private_connection.id
	}
}
