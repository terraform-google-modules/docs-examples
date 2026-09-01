resource "google_storage_ftp_server" "external_server" {
  location     = "us-west1"
  server_id    = "sftp-ext-${local.name_suffix}"
  display_name = "My SFTP Server"
  access_type  = "EXTERNAL"

  external_config {
    allowed_cidr_blocks = [
      "192.168.1.0/24",
      "10.0.0.0/8"
    ]
  }
}
