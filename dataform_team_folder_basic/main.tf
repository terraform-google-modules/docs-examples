resource "google_dataform_team_folder" "dataform_team_folder_basic" {
  region = "us-central1"
  display_name = "Basic TeamFolder-%{random_suffix}"
}
