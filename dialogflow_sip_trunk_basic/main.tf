resource "google_dialogflow_sip_trunk" "basic_trunk" {
  display_name = "basic-trunk-${local.name_suffix}"
  location     = "europe-west3"
  expected_hostname = [
    "basic-trunk-${local.name_suffix}.example.com"
  ]
}
