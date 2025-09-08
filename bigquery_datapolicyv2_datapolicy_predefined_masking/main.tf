resource "google_bigquery_datapolicyv2_data_policy" "predefined_masking_data_policy" {
  location         = "us-central1"
  data_policy_type = "DATA_MASKING_POLICY"
  data_masking_policy {
    predefined_expression = "SHA256"
  }
  data_policy_id   = "predefined_masking_data_policy-${local.name_suffix}"
}
