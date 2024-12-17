resource "google_network_connectivity_hub" "primary"  {
 name        = "star-${local.name_suffix}"
 description = "A sample star hub"
 labels = {
    label-one = "value-one"
  }
 preset_topology = "STAR"
  
}
