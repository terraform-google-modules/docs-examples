resource "google_workload_identity_service_agent" "primary" {
  parent   = "projects/${data.google_project.project.number}/locations/global/serviceProducers/chemisttest.googleapis.com"
}

data "google_project" "project" {
}
