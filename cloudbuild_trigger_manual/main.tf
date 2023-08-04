
resource "google_cloudbuild_trigger" "manual-trigger" {
  name        = "manual-trigger-${local.name_suffix}"

  source_to_build {
    uri       = "https://hashicorp/terraform-provider-google-beta"
    ref       = "refs/heads/main"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.yaml"
    uri       = "https://hashicorp/terraform-provider-google-beta"
    revision  = "refs/heads/main"
    repo_type = "GITHUB"
  }

  
  // If this is set on a build, it will become pending when it is run, 
  // and will need to be explicitly approved to start.
  approval_config {
     approval_required = true 
  }
   
  
}
