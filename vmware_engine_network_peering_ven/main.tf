resource "google_vmwareengine_network" "network-peering-nw" {
   name              = "default-np-nw-${local.name_suffix}"
   location          = "global"
   type              = "STANDARD"
}
resource "google_vmwareengine_network" "network-peering-peer-nw" {
   name              = "peer-np-nw-${local.name_suffix}"
   location          = "global"
   type              = "STANDARD"
}
resource "google_vmwareengine_network_peering" "vmw-engine-network-peering" {
    name = "sample-network-peering-${local.name_suffix}"
    description = "Sample description"
    vmware_engine_network = google_vmwareengine_network.network-peering-nw.id
    peer_network = google_vmwareengine_network.network-peering-peer-nw.id
    peer_network_type = "VMWARE_ENGINE_NETWORK"
    export_custom_routes = false
    import_custom_routes = false
    export_custom_routes_with_public_ip = false
    import_custom_routes_with_public_ip = false
}
