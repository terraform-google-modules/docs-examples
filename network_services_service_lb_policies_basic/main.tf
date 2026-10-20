resource "google_network_services_service_lb_policies" "default" {
  name        = "my-lb-policy-${local.name_suffix}"
  location    = "global"
}
