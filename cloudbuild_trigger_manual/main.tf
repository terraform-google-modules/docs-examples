resource "google_cloudbuild_trigger" "manual-trigger" {
  name = "manual-trigger-${local.name_suffix}"

  build {
    step {
      name = "gcr.io/cloud-builders/gcloud"
      args = ["version"]
    }
  }

  // approval_config can be used with any trigger type, not just manual triggers.
  // If this is set on a build, it will become pending when it is run,
  // and will need to be explicitly approved to start.
  approval_config {
     approval_required = true 
  }
}
