resource "google_network_security_url_lists" "default" {
  name        = "my-url-lists-${local.name_suffix}"
  location    = "us-central1"
  values = ["www.example.com"]
}
