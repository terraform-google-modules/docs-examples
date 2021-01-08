resource "google_vpc_access_connector" "connector" {
  name          = "vpc-con-${local.name_suffix}"
  region        = "us-central1"
  ip_cidr_range = "10.8.0.0/28"
  network       = "default"
}
