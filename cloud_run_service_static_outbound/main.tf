# Example of setting up a Cloud Run service with a static outbound IP

resource "google_compute_network" "default" {
  name = "cr-static-ip-network-${local.name_suffix}"
}

resource "google_compute_subnetwork" "default" {
  name          = "cr-static-ip-${local.name_suffix}"
  ip_cidr_range = "10.124.0.0/28"
  network       = google_compute_network.default.id
  region        = "us-central1"
}

resource "google_project_service" "vpc" {
  service = "vpcaccess.googleapis.com"
}

resource "google_vpc_access_connector" "default" {
  provider = google-beta
  name     = "cr-conn-${local.name_suffix}"

  subnet {
    name = google_compute_subnetwork.default.name
  }

  # Wait for VPC API enablement
  # before creating this resource
  depends_on = [
    google_project_service.vpc
  ]
}

resource "google_compute_router" "default" {
  name    = "cr-static-ip-router-${local.name_suffix}"
  network = google_compute_network.default.name
  region  = google_compute_subnetwork.default.region
}

resource "google_compute_address" "default" {
  name   = "cr-static-ip-addr-${local.name_suffix}"
  region = google_compute_subnetwork.default.region
}

resource "google_compute_router_nat" "default" {
  name   = "cr-static-nat-${local.name_suffix}"
  router = google_compute_router.default.name
  region = google_compute_subnetwork.default.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.default.self_link]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.default.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_cloud_run_service" "default" {
  name     = "cr-static-ip-service-${local.name_suffix}"
  location = google_compute_subnetwork.default.region

  template {
    spec {
      containers {
        # TODO<developer>: replace with a URL to your container
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  metadata {
    annotations = {
      "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.default.name
      "run.googleapis.com/vpc-access-egress"    = "all-traffic"
      "run.googleapis.com/ingress"              = "all"
    }
  }
}
