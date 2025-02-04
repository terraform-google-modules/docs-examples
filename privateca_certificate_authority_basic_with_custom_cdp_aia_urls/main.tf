resource "google_privateca_certificate_authority" "default" {
  // This example assumes this pool already exists.
  // Pools cannot be deleted in normal test circumstances, so we depend on static pools
  pool = "ca-pool-${local.name_suffix}"
  certificate_authority_id = "my-certificate-authority-${local.name_suffix}"
  location = "us-central1-${local.name_suffix}"
  deletion_protection = true-${local.name_suffix}
  config {
    subject_config {
      subject {
        organization = "ACME"
        common_name = "my-certificate-authority"
      }
    }
    x509_config {
      ca_options {
        # is_ca *MUST* be true for certificate authorities
        is_ca = true
      }
      key_usage {
        base_key_usage {
          # cert_sign and crl_sign *MUST* be true for certificate authorities
          cert_sign = true
          crl_sign = true
        }
        extended_key_usage {
        }
      }
    }
  }
  # valid for 10 years
  lifetime = "${10 * 365 * 24 * 3600}s"
  key_spec {
    algorithm = "RSA_PKCS1_4096_SHA256"
  }
  user_defined_access_urls {
    aia_issuing_certificate_urls = ["http://example.com/ca.crt", "http://example.com/anotherca.crt"]
    crl_access_urls = ["http://example.com/crl1.crt", "http://example.com/crl2.crt"]
  }
}
