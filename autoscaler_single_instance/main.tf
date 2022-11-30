resource "google_compute_autoscaler" "default" {
  provider = google-beta

  name   = "my-autoscaler-${local.name_suffix}"
  zone   = "us-central1-f"
  target = google_compute_instance_group_manager.default.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    metric {
      name                       = "pubsub.googleapis.com/subscription/num_undelivered_messages"
      filter                     = "resource.type = pubsub_subscription AND resource.label.subscription_id = our-subscription"
      single_instance_assignment = 65535
    }
  }
}

resource "google_compute_instance_template" "default" {
  provider = google-beta

  name           = "my-instance-template-${local.name_suffix}"
  machine_type   = "e2-medium"
  can_ip_forward = false

  tags = ["foo", "bar"]

  disk {
    source_image = data.google_compute_image.debian_9.id
  }

  network_interface {
    network = "default"
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_target_pool" "default" {
  provider = google-beta

  name = "my-target-pool-${local.name_suffix}"
}

resource "google_compute_instance_group_manager" "default" {
  provider = google-beta

  name = "my-igm-${local.name_suffix}"
  zone = "us-central1-f"

  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }

  target_pools       = [google_compute_target_pool.default.id]
  base_instance_name = "autoscaler-sample"
}

data "google_compute_image" "debian_9" {
  provider = google-beta

  family  = "debian-11"
  project = "debian-cloud"
}

provider "google-beta" {
  region = "us-central1"
  zone   = "us-central1-a"
  
}
