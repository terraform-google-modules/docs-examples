resource "google_netapp_kmsconfig" "kmsConfig" {
  name = "kms-test-${local.name_suffix}"
  description="this is a test description"
  crypto_key_name="crypto-name-${local.name_suffix}"
  location="us-central1"
}
