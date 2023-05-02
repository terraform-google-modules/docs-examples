resource "google_network_security_authorization_policy" "default" {
  provider               = google-beta
  name                   = "my-authorization-policy-${local.name_suffix}"
  labels                 = {
    foo = "bar"
  }
  description            = "my description"
  action                 = "ALLOW"
  rules {
    sources {
      principals = ["namespace/*"]
      ip_blocks = ["1.2.3.0/24"]
    }
    destinations {
      hosts = ["mydomain.*"]
      ports = [8080]
      methods = ["GET"]
      http_header_match {
        header_name = ":method"
        regex_match = "GET"
      }
    }
  }
}
