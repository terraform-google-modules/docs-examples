resource "google_network_connectivity_hub" "primary"  {
 name        = "basic-${local.name_suffix}"
 description = "A sample hub"
 labels = {
    label-one = "value-one"
  }
}
