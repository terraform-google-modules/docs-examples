resource "google_vpc_access_connector" "connector" {
  name          = "vpcconn-${local.name_suffix}"
  region        = "us-central1"
  ip_cidr_range = "10.8.0.0/28"
  network       = "default"
}
