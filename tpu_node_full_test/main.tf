data "google_tpu_tensorflow_versions" "available" {
}


resource "google_tpu_node" "tpu" {
  name = "test-tpu-${local.name_suffix}"
  zone = "us-central1-b"

  accelerator_type = "v3-8"

  tensorflow_version = data.google_tpu_tensorflow_versions.available.versions[0]

  description = "Terraform Google Provider test TPU"
  use_service_networking = true
  network = data.google_compute_network.network.id

  labels = {
    foo = "bar"
  }

  scheduling_config {
    preemptible = true
  }
}

data "google_compute_network" "network" {
  name = "tpu-node-network-${local.name_suffix}"
}
