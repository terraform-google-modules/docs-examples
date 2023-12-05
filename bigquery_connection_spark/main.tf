resource "google_bigquery_connection" "connection" {
   connection_id = "my-connection-${local.name_suffix}"
   location      = "US"
   friendly_name = "👋"
   description   = "a riveting description"
   spark {
      spark_history_server_config {
         dataproc_cluster = google_dataproc_cluster.basic.id
      }
   }
}

resource "google_dataproc_cluster" "basic" {
   name   = "my-connection-${local.name_suffix}"
   region = "us-central1"

   cluster_config {
     # Keep the costs down with smallest config we can get away with
     software_config {
       override_properties = {
         "dataproc:dataproc.allow.zero.workers" = "true"
       }
     }
 
     master_config {
       num_instances = 1
       machine_type  = "e2-standard-2"
       disk_config {
         boot_disk_size_gb = 35
       }
     }
   }   
 }
