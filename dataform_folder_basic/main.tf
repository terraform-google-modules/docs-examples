resource "google_dataform_folder" "dataform_folder_basic" {
  region = "us-central1"
  display_name = "Basic Folder-%{random_suffix}"
}
