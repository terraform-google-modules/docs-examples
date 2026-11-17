resource "google_saas_runtime_saas" "example_saas" {
  saas_id  = "example-saas-${local.name_suffix}"
  location = "global"

  locations {
    name = "us-central1"
  }
}

resource "google_saas_runtime_unit_kind" "example_unitkind" {
  location     = "global"
  unit_kind_id = "example-unitkind-${local.name_suffix}"
  saas         = google_saas_runtime_saas.example_saas.id
}

resource "google_saas_runtime_release" "example_previous" {
  location          = "global"
  release_id        = "previous-release-${local.name_suffix}"
  unit_kind         = google_saas_runtime_unit_kind.example_unitkind.id
  blueprint {
    package = "us-central1-docker.pkg.dev/ci-test-project-188019/test-repo/tf-test-easysaas-alpha-image@sha256:16f50ddbcbc7926ad9d4f09fa6c37306b88ccc4d6370f627a4733b1ab0823680"
  }
}

resource "google_saas_runtime_release" "example" {
  location          = "global"
  release_id        = "example-release-${local.name_suffix}"
  unit_kind         = google_saas_runtime_unit_kind.example_unitkind.id
  blueprint {
    package = "us-central1-docker.pkg.dev/ci-test-project-188019/test-repo/tf-test-easysaas-beta-image@sha256:c28fbfbb6c5d8ee1c1c1a00561df17c8e47d2c5b673c61ce0c189de9a27ae09a"
  }
  input_variable_defaults {
    variable = "name"
    value    = "test"
    type     = "STRING"
  }
}
