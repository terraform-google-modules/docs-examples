resource "google_datastream_private_connection" "default" {
    display_name          = "Connection profile"
    location              = "us-west1"
    private_connection_id = "my-connection-${local.name_suffix}"

    labels = {
        key = "value"
    }

    psc_interface_config {
        network_attachment = google_compute_network_attachment.default.id
    }
}

resource "google_compute_network_attachment" "default" {
    name                  = "my-network-attachment-${local.name_suffix}"
    region                = "us-west1"
    description           = "basic network attachment description"
    connection_preference = "ACCEPT_AUTOMATIC"

    subnetworks = [
        google_compute_subnetwork.default.self_link
    ]
}

resource "google_compute_network" "default" {
    name                    = "my-network-${local.name_suffix}"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
    name   = "my-subnetwork-${local.name_suffix}"
    region = "us-west1"

    network       = google_compute_network.default.id
    ip_cidr_range = "10.0.0.0/16"
}
