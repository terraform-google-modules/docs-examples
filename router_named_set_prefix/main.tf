resource "google_compute_network" "net" {
  name                    = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_router" "router" {
  name    = "my-router-${local.name_suffix}"
  network = google_compute_network.net.name
  region  = "us-central1"
}

resource "google_compute_router_named_set" "prefix_set" {
  name        = "my-prefix-set-${local.name_suffix}"
  router      = google_compute_router.router.name
  region      = "us-central1"
  description = "A sample prefix named set"
  type        = "NAMED_SET_TYPE_PREFIX"
  
  elements {
    expression  = "'10.0.0.0/8'"
    title       = "ten-slash-eight"
    description = "A sample IPv4 prefix"
  }

  elements {
    expression  = "'172.16.0.0/12'"
    title       = "seventeen-two-slash-sixteen"
  }
}
