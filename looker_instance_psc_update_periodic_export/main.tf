provider "google" {
  prefer_regional_endpoints = true
}

resource "google_storage_bucket" "export" {
  name          = "looker-export-${local.name_suffix}"
  location      = "US"
  force_destroy = true
}

resource "google_kms_key_ring" "keyring" {
  name     = "looker-keyring-${local.name_suffix}"
  location = "us-west1"
}

resource "google_kms_crypto_key" "key" {
  name     = "looker-key-${local.name_suffix}"
  key_ring = google_kms_key_ring.keyring.id
}

resource "google_looker_instance" "looker-instance" {
  name              = "my-instance-${local.name_suffix}"
  platform_edition  = "LOOKER_CORE_ENTERPRISE_ANNUAL"
  region            = "us-central1"
  public_ip_enabled = true
  psc_enabled       = true

  psc_config {
    allowed_vpcs = []
  }

  controlled_egress_enabled = true

  controlled_egress_config {
    marketplace_enabled = true
    egress_fqdns        = ["google.com", "github.com"]
  }

  periodic_export_config {
    gcs_uri = "gs://${google_storage_bucket.export.name}"
    kms_key = google_kms_crypto_key.key.id

    start_time {
      hours   = 12
      minutes = 30
      seconds = 0
      nanos   = 0
    }
  }

  oauth_config {
    client_id     = "my-client-id-${local.name_suffix}"
    client_secret = "my-client-secret-${local.name_suffix}"
  }
}
