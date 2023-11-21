resource "google_vmwareengine_network" "vmw-engine-network" {
    name              = "standard-nw"
    location          = "global" # Standard network needs to be global
    type              = "STANDARD"
    description       = "VMwareEngine standard network sample"
}
