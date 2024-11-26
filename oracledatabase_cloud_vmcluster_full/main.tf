resource "google_oracle_database_cloud_vm_cluster" "my_vmcluster"{
  cloud_vm_cluster_id = "my-instance-${local.name_suffix}"
  display_name = "my-instance-${local.name_suffix} displayname"
  location = "us-east4"
  project = "my-project-${local.name_suffix}"
  exadata_infrastructure = google_oracle_database_cloud_exadata_infrastructure.cloudExadataInfrastructures.id
  network = data.google_compute_network.default.id
  cidr = "10.5.0.0/24"
  backup_subnet_cidr = "10.6.0.0/24"
  labels = {
    label-one = "value-one"
  }
  properties {
    license_type = "LICENSE_INCLUDED"
    ssh_public_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCz1X2744t+6vRLmE5u6nHi6/QWh8bQDgHmd+OIxRQIGA/IWUtCs2FnaCNZcqvZkaeyjk5v0lTA/n+9jvO42Ipib53athrfVG8gRt8fzPL66C6ZqHq+6zZophhrCdfJh/0G4x9xJh5gdMprlaCR1P8yAaVvhBQSKGc4SiIkyMNBcHJ5YTtMQMTfxaB4G1sHZ6SDAY9a6Cq/zNjDwfPapWLsiP4mRhE5SSjJX6l6EYbkm0JeLQg+AbJiNEPvrvDp1wtTxzlPJtIivthmLMThFxK7+DkrYFuLvN5AHUdo9KTDLvHtDCvV70r8v0gafsrKkM/OE9Jtzoo0e1N/5K/ZdyFRbAkFT4QSF3nwpbmBWLf2Evg//YyEuxnz4CwPqFST2mucnrCCGCVWp1vnHZ0y30nM35njLOmWdRDFy5l27pKUTwLp02y3UYiiZyP7d3/u5pKiN4vC27VuvzprSdJxWoAvluOiDeRh+/oeQDowxoT/Oop8DzB9uJmjktXw8jyMW2+Rpg+ENQqeNgF1OGlEzypaWiRskEFlkpLb4v/s3ZDYkL1oW0Nv/J8LTjTOTEaYt2Udjoe9x2xWiGnQixhdChWuG+MaoWffzUgx1tsVj/DBXijR5DjkPkrA1GA98zd3q8GKEaAdcDenJjHhNYSd4+rE9pIsnYn7fo5X/tFfcQH1XQ== nobody@google.com"]
    cpu_core_count = "4"
    gi_version = "19.0.0.0"
    time_zone {
        id = "UTC"
    }
    node_count = "2"
    ocpu_count = "4.0"
    data_storage_size_tb    = 2
    db_node_storage_size_gb = 120
    db_server_ocids = [data.google_oracle_database_db_servers.mydbserver.db_servers.0.properties.0.ocid, data.google_oracle_database_db_servers.mydbserver.db_servers.1.properties.0.ocid]
    disk_redundancy = "HIGH"
    sparse_diskgroup_enabled = false
    local_backup_enabled = false
    cluster_name = "pq-ppat4"
    hostname_prefix = "hostname1"
    diagnostics_data_collection_options {
      diagnostics_events_enabled = true
      health_monitoring_enabled  = true
      incident_logs_enabled      = true
    }
    memory_size_gb = 60
  }

  deletion_protection = "true-${local.name_suffix}"
}

resource "google_oracle_database_cloud_exadata_infrastructure" "cloudExadataInfrastructures"{
  cloud_exadata_infrastructure_id = "my-exadata-${local.name_suffix}"
  display_name = "my-exadata-${local.name_suffix} displayname"
  location = "us-east4"
  project = "my-project-${local.name_suffix}"
  properties {
    shape = "Exadata.X9M"
    compute_count= "2"
    storage_count= "3"
  }

  deletion_protection = "true-${local.name_suffix}"
}

data "google_compute_network" "default" {
  name     = "new"
  project = "my-project-${local.name_suffix}"
}

data "google_oracle_database_db_servers" "mydbserver" {
  location = "us-east4"
  project = "my-project-${local.name_suffix}"
  cloud_exadata_infrastructure = google_oracle_database_cloud_exadata_infrastructure.cloudExadataInfrastructures.cloud_exadata_infrastructure_id
}
