resource "google_game_services_realm" "default" {
  realm_id  = "tf-test-realm-${local.name_suffix}"
  time_zone = "EST"
  location  = "global"

  description = "one of the nine"
}
