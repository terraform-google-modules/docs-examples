resource "google_container_analysis_note" "note" {
  name = "attestor-note-${local.name_suffix}"
  attestation_authority {
    hint {
      human_readable_name = "Attestor Note"
    }
  }
}
