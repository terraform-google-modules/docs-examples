data "google_project" "project" {
}

resource "google_kms_crypto_key_iam_member" "kms_iam" {
  crypto_key_id = "kms-key-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-geminidataanalytics.iam.gserviceaccount.com"
}

resource "google_gemini_data_analytics_data_agent" "example" {
  location      = "us-central1"
  data_agent_id = "data-agent-cmek-${local.name_suffix}"
  display_name  = "CMEK data agent"
  description   = "Example Gemini Data Analytics data agent with customer-managed encryption."

  kms_key = "kms-key-${local.name_suffix}"

  data_analytics_agent {
    staging_context {
      system_instruction = "Answer questions about the sample Shakespeare corpus."

      datasource_references {
        bq {
          table_references {
            project_id = "bigquery-public-data"
            dataset_id = "samples"
            table_id   = "shakespeare"
          }
        }
      }
    }
  }

  depends_on = [google_kms_crypto_key_iam_member.kms_iam]
}
