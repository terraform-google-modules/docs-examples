resource "google_game_services_game_server_cluster" "default" {
    
  cluster_id = ""
  realm_id   = google_game_services_realm.default.realm_id

  connection_info {
    gke_cluster_reference {
      cluster = "locations/us-west1/clusters/%{agones_cluster}"
    }
    namespace = "default"
  }
}

resource "google_game_services_realm" "default" {
  realm_id   = "realm-${local.name_suffix}"
  time_zone  = "PST8PDT"

  description = "Test Game Realm"
}
