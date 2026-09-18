resource "google_compute_zone_vm_extension_policy" "ops_agent_policy" {
  name        = "zonal-ops-agent-policy-${local.name_suffix}"
  zone        = "us-central1-a"

  extension_policies {
    extension_name = "ops-agent"
    pinned_version = "2.66.0"
  }
}
