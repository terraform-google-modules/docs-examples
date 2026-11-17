resource "google_compute_network" "network-peering-vpc" {
  name = "default-vpc-${local.name_suffix}"
}
resource "google_vmwareengine_network" "network-peering-standard-nw" {
   name              = "default-standard-nw-np-${local.name_suffix}"
   location          = "global"
   type              = "STANDARD"
}
resource "google_vmwareengine_network_peering" "vmw-engine-network-peering" {
    name = "sample-network-peering-${local.name_suffix}"
    description = "Sample description"
    peer_network = google_compute_network.network-peering-vpc.id
    peer_network_type = "STANDARD"
    vmware_engine_network = google_vmwareengine_network.network-peering-standard-nw.id
}
