resource "google_compute_interconnect_attachment_group" "example-interconnect-attachment-group" {
  name   = "example-interconnect-attachment-group-${local.name_suffix}"
  intent {
    availability_sla = "NO_SLA"
  }
}
