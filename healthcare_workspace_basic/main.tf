resource "google_healthcare_workspace" "default" {
  name    = "example-dm-workspace-${local.name_suffix}"
  dataset = google_healthcare_dataset.dataset.id

  settings {
    data_project_ids = ["example-data-source-project-id-${local.name_suffix}"]
  }
  
  labels = {
    label1 = "labelvalue1"
  }
}


resource "google_healthcare_dataset" "dataset" {
  name     = "example-dataset-${local.name_suffix}"
  location = "us-central1"
}
