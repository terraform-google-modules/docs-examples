data "google_project" "project" {
}

resource "google_tags_tag_key" "tag_key" {
  parent     = "projects/${data.google_project.project.number}"
  short_name = "keyname-${local.name_suffix}"
}

resource "google_tags_tag_value" "tag_value" {
  parent     = "tagKeys/${google_tags_tag_key.tag_key.name}"
  short_name = "valuename-${local.name_suffix}"
}

resource "google_workstations_workstation_cluster" "default" {
  workstation_cluster_id = "workstation-cluster-tags-${local.name_suffix}"
  network                = google_compute_network.default.id
  subnetwork             = google_compute_subnetwork.default.id
  location               = "us-central1"
  
  tags = {
    "${data.google_project.project.project_id}/${google_tags_tag_key.tag_key.short_name}" = "${google_tags_tag_value.tag_value.short_name}"
  }
}

resource "google_compute_network" "default" {
  name                    = "workstation-cluster-tags-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "workstation-cluster-tags-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.default.name
}
