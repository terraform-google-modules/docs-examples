resource "google_network_connectivity_hub" "primary"  {
 name        = "mesh-${local.name_suffix}"
 description = "A sample mesh hub"
 labels = {
    label-one = "value-one"
  }
}
