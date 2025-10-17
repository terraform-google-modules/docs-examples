resource "google_bigquery_datapolicyv2_data_policy" "basic_data_policy" {
  location         = "us-central1"
  data_policy_type = "RAW_DATA_ACCESS_POLICY"
  data_policy_id   = "basic_data_policy-${local.name_suffix}"
}
