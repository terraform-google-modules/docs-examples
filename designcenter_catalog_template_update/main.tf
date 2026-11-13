resource "google_design_center_catalog_template" "example" {
  project             = "my-project-name"
  location            = "us-central1"
  space               = "example-space"
  catalog             = "example-catalog"
  catalog_template_id = "example-catalog-template-${local.name_suffix}"
  template_category   = "APPLICATION_TEMPLATE"
  type                = "COMPOSITE_APPLICATION_TEMPLATE"
  display_name        = "Updated Example Design Center Catalog Template"
  description         = "Updated Managed by Terraform"
}
