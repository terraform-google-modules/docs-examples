resource "google_compute_address" "default" {
  name             = "test-address-${local.name_suffix}"
  region           = "us-central1"
  ip_collection    = google_compute_public_delegated_prefix.sub_pdp.self_link
}

resource "google_compute_public_delegated_prefix" "sub_pdp" {
  name             = "test-sub-pdp-${local.name_suffix}"
  region           = "us-central1"
  ip_cidr_range    = ""136.124.3.120/32"-${local.name_suffix}"
  parent_prefix    = ""projects/tf-static-byoip/regions/us-central1/publicDelegatedPrefixes/tf-enhanced-pdp-136-124-3-120-29"-${local.name_suffix}"
}
