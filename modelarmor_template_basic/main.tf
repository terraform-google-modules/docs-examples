resource "google_model_armor_template" "template-basic" {
  location    = "us-central1-${local.name_suffix}"
  template_id = "modelarmor1-${local.name_suffix}"

  filter_config {

  }

  template_metadata {

  }
}
