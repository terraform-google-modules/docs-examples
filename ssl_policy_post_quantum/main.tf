resource "google_compute_ssl_policy" "post-quantum-ssl-policy" {
  name                         = "post-quantum-ssl-policy-${local.name_suffix}"
  profile                      = "MODERN"
  min_tls_version              = "TLS_1_2"
  post_quantum_key_exchange    = "ENABLED"
}
