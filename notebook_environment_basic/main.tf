resource "google_notebooks_environment" "environment" {
  name = "notebooks-environment-${local.name_suffix}"
  location = "us-west1-a"  
  container_image {
    repository = "gcr.io/deeplearning-platform-release/base-cpu"
  } 
}
