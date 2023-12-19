resource "google_compute_network_firewall_policy" "policy" {
  name = "tf-test-policy-${local.name_suffix}"
  description = "Terraform test"
}
