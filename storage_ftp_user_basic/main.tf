resource "google_storage_bucket" "bucket" {
  name                        = "sftp-bucket-${local.name_suffix}"
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_service_account" "sa" {
  account_id   = "sftp-sa-${local.name_suffix}"
  display_name = "Storage FTP Service Account"
}

resource "google_storage_ftp_server" "server" {
  location     = "us-west1"
  server_id    = "sftp-srv-${local.name_suffix}"
  display_name = "My SFTP Server"
  access_type  = "EXTERNAL"

  external_config {
    allowed_cidr_blocks = [
      "192.168.1.0/24",
      "10.0.0.0/8"
    ]
  }
}

resource "google_storage_ftp_user" "user_ftp" {
  location                 = "us-west1"
  server_id                = google_storage_ftp_server.server.server_id
  user_id                  = "sftp-user-${local.name_suffix}"
  customer_service_account = google_service_account.sa.email

  storage_directory_mappings {
    bucket        = google_storage_bucket.bucket.name
    bucket_prefix = "my-prefix-1"
    directory     = "/dir-1"
    permission    = "READ_ONLY"
  }
  storage_directory_mappings {
    bucket        = google_storage_bucket.bucket.name
    bucket_prefix = "my-prefix-2"
    directory     = "/dir-2"
    permission    = "READ_ONLY"
  }

  user_credentials {
    credential_name     = "ssh-key-credential"
    credential_type     = "PUBLIC_KEY"
    ssh_public_key_body = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPM4pxpbPpjuBocS6qlW0BHRYgH5xmv/yVrANZR9lc1N user@example.com"
  }
}
