resource "google_bigquery_connection" "connection" {
   connection_id = "my-connection-${local.name_suffix}"
   location      = "aws-us-east-1"
   friendly_name = "👋"
   description   = "a riveting description"
   aws { 
      access_role {
         iam_role_id =  "arn:aws:iam::999999999999:role/omnirole-${local.name_suffix}"
      }
   }
}
