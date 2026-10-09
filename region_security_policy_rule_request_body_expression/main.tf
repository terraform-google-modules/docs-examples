resource "google_compute_region_security_policy" "default" {
  name        = "policyruletest-${local.name_suffix}"
  region      = "us-west2"
  description = "basic global security policy"
  type        = "CLOUD_ARMOR"
}

resource "google_compute_region_security_policy_rule" "policy_rule" {
  security_policy = google_compute_region_security_policy.default.name
  region          = "us-west2"
  description     = "Deny requests containing specific body string"
  action          = "deny(403)"
  priority        = 1000
  match {
    expr {
      expression = "request.body.contains('my-match-string')"
    }
  }
}
