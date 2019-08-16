resource "google_container_analysis_note" "note" {
  provider = "google-beta"

  name = "test-attestor-note-${local.name_suffix}"
  attestation_authority {
    hint {
      human_readable_name = "Attestor Note"
    }
  }
}

provider "google-beta"{
  region = "us-central1"
  zone   = "us-central1-a"
}
