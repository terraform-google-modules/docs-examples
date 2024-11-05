resource "google_network_connectivity_hub" "basic_hub"  {
 name        = "network-connectivity-hub1-${local.name_suffix}"
 description = "A sample hub"
 labels = {
    label-one = "value-one"
  }
}

resource "google_network_connectivity_group" "primary"  {
 hub         = google_network_connectivity_hub.basic_hub.id
 name        = "default"
 labels = {
  label-one = "value-one"
 }
 description = "A sample hub group"
 auto_accept {
    auto_accept_projects = [
      "foo-${local.name_suffix}", 
      "bar-${local.name_suffix}", 
    ]
  }
}
