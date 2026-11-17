resource "google_gke_hub_scope" "scope" {
  scope_id = "my-scope-${local.name_suffix}"
  namespace_labels = {
      keyb = "valueb"
      keya = "valuea"
      keyc = "valuec" 
  }
  labels = {
      keyb = "valueb"
      keya = "valuea"
      keyc = "valuec" 
  }
}
