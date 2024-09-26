resource "google_network_connectivity_hub" "primary"  {
 name        = "basic-${local.name_suffix}"
 description = "A sample hub with Private Service Connect transitivity is enabled"
 export_psc = true
}
