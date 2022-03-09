resource "google_sql_database_instance" "instance" {
    provider         = google-beta
    name             = "my-database-instance-${local.name_suffix}"
    database_version = "POSTGRES_11"
    region           = "us-central1"
    settings {
		tier = "db-f1-micro"
	}

    deletion_protection  = "false"
}

resource "google_sql_database" "db" {
    provider = google-beta
    instance = google_sql_database_instance.instance.name
    name     = "db"
}

resource "random_password" "pwd" {
    length = 16
    special = false
}

resource "google_sql_user" "user" {
    provider = google-beta
    name = "user-${local.name_suffix}"
    instance = google_sql_database_instance.instance.name
    password = random_password.pwd.result
}

resource "google_bigquery_connection" "connection" {
    provider      = google-beta
    connection_id = "my-connection-${local.name_suffix}"
    location      = "US"
    friendly_name = "👋"
    description   = "a riveting description"
    cloud_sql {
        instance_id = google_sql_database_instance.instance.connection_name
        database    = google_sql_database.db.name
        type        = "POSTGRES"
        credential {
          username = google_sql_user.user.name
          password = google_sql_user.user.password
        }
    }
}
