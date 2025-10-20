resource "google_compute_region_network_firewall_policy" "policy" {
  name = "rnf-policy-${local.name_suffix}"
  description = "Terraform test"
  policy_type = "RDMA_ROCE_POLICY"
}
