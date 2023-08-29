resource "google_biglake_catalog" "default"  {
    name = "my_catalog-${local.name_suffix}"
    location = "US"
}
