resource "google_compute_network_peering_routes_config" "peering_gke_routes" {
  peering = google_compute_network_peering.peering_gke_to_workload.name
  network = google_compute_network.gke_network.name

  import_custom_routes = true
  export_custom_routes = true
}

resource "google_compute_network_peering" "peering_gke_to_workload" {
  name         = "peering-gke-to-workload-${local.name_suffix}"
  network      = google_compute_network.gke_network.id
  peer_network = google_compute_network.workload_network.id

  import_custom_routes = true
  export_custom_routes = true
}

resource "google_compute_network_peering" "peering_workload_to_gke" {
  name         = "peering-workload-to-gke-${local.name_suffix}"
  network      = google_compute_network.workload_network.id
  peer_network = google_compute_network.gke_network.id
}

resource "google_compute_network" "gke_network" {
  name                    = "gke-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_network" "workload_network" {
  name                    = "workload-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke_subnetwork" {
  name                     = "gke-subnetwork-${local.name_suffix}"
  region                   = "us-central1"
  network                  = google_compute_network.gke_network.name
  ip_cidr_range            = "10.0.36.0/24"
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pod"
    ip_cidr_range = "10.0.0.0/19"
  }

  secondary_ip_range {
    range_name    = "svc"
    ip_cidr_range = "10.0.32.0/22"
  }
}

resource "google_container_cluster" "gke_cluster" {
  name               = "gke-cluster-${local.name_suffix}"
  location           = "us-central1-a"
  initial_node_count = 1

  network    = google_compute_network.gke_network.name
  subnetwork = google_compute_subnetwork.gke_subnetwork.name

  private_cluster_config {
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "10.42.0.0/28"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.gke_subnetwork.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.gke_subnetwork.secondary_ip_range[1].range_name
  }

  deletion_protection = false
}
