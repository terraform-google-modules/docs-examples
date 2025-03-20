resource "google_compute_network" "net" {
  name                    = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnetwork-${local.name_suffix}"
  network       = google_compute_network.net.id
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
}

resource "google_compute_router" "router" {
  name    = "my-router-${local.name_suffix}"
  region  = google_compute_subnetwork.subnet.region
  network = google_compute_network.net.id
}

resource "google_compute_router_route_policy" "rp-import" {
  name = "my-rp2-${local.name_suffix}"
  router = google_compute_router.router.name
  region = google_compute_router.router.region
	type = "ROUTE_POLICY_TYPE_IMPORT"
	terms {
    priority = 2
    match {
      expression = "destination == '10.0.0.0/12'"
	  }
    actions {
      expression = "accept()"
    }
  }
}
