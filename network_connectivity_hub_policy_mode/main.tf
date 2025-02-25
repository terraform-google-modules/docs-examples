
resource "google_network_connectivity_hub" "primary" {
 name            = "policy-${local.name_suffix}"
 description     = "A sample hub with PRESET policy_mode and STAR topology"
 policy_mode     = "PRESET"
 preset_topology = "STAR"
 labels = {
    label-one = "value-one"
  }
}
