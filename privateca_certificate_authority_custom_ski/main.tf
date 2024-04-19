resource "google_privateca_certificate_authority" "default" {
 // This example assumes this pool already exists.
 // Pools cannot be deleted in normal test circumstances, so we depend on static pools
  pool = "ca-pool-${local.name_suffix}"
  certificate_authority_id = "my-certificate-authority-${local.name_suffix}"
  location = "us-central1-${local.name_suffix}"
  deletion_protection = "true-${local.name_suffix}"
  config {
    subject_config {
      subject {
        organization = "HashiCorp"
        common_name = "my-certificate-authority"
      }
      subject_alt_name {
        dns_names = ["hashicorp.com"]
      }
    }
    subject_key_id {
        key_id = "4cf3372289b1d411b999dbb9ebcd44744b6b2fca"
    }
    x509_config {
      ca_options {
        is_ca = true
        max_issuer_path_length = 10
      }
      key_usage {
        base_key_usage {
          digital_signature = true
          content_commitment = true
          key_encipherment = false
          data_encipherment = true
          key_agreement = true
          cert_sign = true
          crl_sign = true
          decipher_only = true
        }
        extended_key_usage {
          server_auth = true
          client_auth = false
          email_protection = true
          code_signing = true
          time_stamping = true
        }
      }
    }
  }
  lifetime = "86400s"
  key_spec {
    cloud_kms_key_version = "projects/keys-project/locations/us-central1/keyRings/key-ring/cryptoKeys/crypto-key-${local.name_suffix}/cryptoKeyVersions/1"
  }
}
