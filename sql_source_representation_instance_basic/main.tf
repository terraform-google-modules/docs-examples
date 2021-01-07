resource "google_sql_source_representation_instance" "instance" {
  name             = "my-instance-${local.name_suffix}"
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  host             = "10.20.30.40"
  port             = 3306
}
