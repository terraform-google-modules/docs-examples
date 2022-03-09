resource "google_os_config_guest_policies" "guest_policies" {
  provider = google-beta
  guest_policy_id = "guest-policy-${local.name_suffix}"

  assignment {
    zones = ["us-east1-b", "us-east1-d"]
  }

  recipes {
    name          = "guest-policy-${local.name_suffix}-recipe"
    desired_state = "INSTALLED"

    artifacts {
      id = "guest-policy-${local.name_suffix}-artifact-id"

      gcs {
        bucket     = "my-bucket"
        object     = "executable.msi"
        generation = 1546030865175603
      }
    }

    install_steps {
      msi_installation {
        artifact_id = "guest-policy-${local.name_suffix}-artifact-id"
      }
    }
  }
}
