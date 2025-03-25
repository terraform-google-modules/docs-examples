resource "google_datastream_connection_profile" "default" {
    display_name              = "Postgres Source With Secret Manager"
    location                  = "us-central1"
    connection_profile_id     = "source-profile-${local.name_suffix}"
    create_without_validation = true


    postgresql_profile {
        hostname = "fake-hostname"
        port = 3306
        username = "fake-username"
        secret_manager_stored_password = "projects/fake-project/secrets/fake-secret/versions/1"
        database = "fake-database"
    }
}
