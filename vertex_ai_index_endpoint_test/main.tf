resource "google_project_service_identity" "vertexai_sa" {
  service = "aiplatform.googleapis.com"
}

resource "google_kms_crypto_key_iam_member" "vertexai_encrypterdecrypter" {
  crypto_key_id = "kms-name-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        =  google_project_service_identity.vertexai_sa.member
}

resource "google_vertex_ai_index_endpoint" "index_endpoint" {
  display_name = "sample-endpoint"
  description  = "A sample vertex endpoint"
  region       = "us-central1"
  labels       = {
    label-one = "value-one"
  }
  network      = "projects/${data.google_project.project.number}/global/networks/${data.google_compute_network.vertex_network.name}"

  encryption_spec {
    kms_key_name = "kms-name-${local.name_suffix}"
  }

  depends_on = [
    google_kms_crypto_key_iam_member.vertexai_encrypterdecrypter,
  ]
}

data "google_compute_network" "vertex_network" {
  name       = "network-name-${local.name_suffix}"
}

data "google_project" "project" {}
