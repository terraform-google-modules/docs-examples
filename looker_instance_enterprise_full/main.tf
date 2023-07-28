resource "google_looker_instance" "looker-instance" {
  name               = "my-instance-${local.name_suffix}"
  platform_edition   = "LOOKER_CORE_ENTERPRISE_ANNUAL"
  region             = "us-central1"
  private_ip_enabled = true
  public_ip_enabled  = false
  reserved_range     = "${google_compute_global_address.looker_range.name}"
  consumer_network   = data.google_compute_network.looker_network.id
  admin_settings {
    allowed_email_domains = ["google.com"]
  }
  encryption_config {
    kms_key_name = "looker-kms-key-${local.name_suffix}"
  }
  maintenance_window {
    day_of_week = "THURSDAY"
    start_time {
      hours   = 22
      minutes = 0
      seconds = 0
      nanos   = 0
    }
  }
  deny_maintenance_period {
    start_date {
      year = 2050
      month = 1
      day = 1
    }
    end_date {
      year = 2050
      month = 2
      day = 1
    }
    time {
      hours = 10
      minutes = 0
      seconds = 0
      nanos = 0
    }
  }
  oauth_config {
    client_id = "my-client-id-${local.name_suffix}"
    client_secret = "my-client-secret-${local.name_suffix}"
  }
  depends_on   = [
    google_service_networking_connection.looker_vpc_connection
  ]
}

resource "google_service_networking_connection" "looker_vpc_connection" {
  network                 = data.google_compute_network.looker_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.looker_range.name]
}

resource "google_compute_global_address" "looker_range" {
  name          = "looker-range-${local.name_suffix}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = data.google_compute_network.looker_network.id
}

data "google_project" "project" {}

data "google_compute_network" "looker_network" {
  name = "looker-network-${local.name_suffix}"
}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = "looker-kms-key-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-looker.iam.gserviceaccount.com"
}
