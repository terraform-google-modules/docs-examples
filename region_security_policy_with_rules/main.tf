resource "google_compute_region_security_policy" "region-sec-policy-with-rules" {
  name        = "my-sec-policy-with-rules-${local.name_suffix}"
  description = "basic region security policy with multiple rules"
  type        = "CLOUD_ARMOR"

  rules {
    action   = "deny"
    priority = "1000"
    match {
      expr {
        expression = "request.path.matches(\"/login.html\") && token.recaptcha_session.score < 0.2"
      }
    }
  }

  rules {
    action   = "deny"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
  }
}
