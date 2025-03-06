resource "google_eventarc_channel" "primary" {
  location = "us-central1"
  name     = "some-channel-${local.name_suffix}"
}
