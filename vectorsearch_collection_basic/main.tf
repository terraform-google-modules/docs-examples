resource "google_vector_search_collection" "example-collection" {
  location      = "us-central1"
  collection_id = "example-collection-${local.name_suffix}"

  display_name = "My Awesome Collection"
  description  = "This collection stores important data."

  labels = {
    env  = "dev"
    team = "my-team"
  }

  data_schema = <<EOF
{
  "type": "object",
  "properties": {
    "title": {
      "type": "string"
    },
    "plot": {
      "type": "string"
    }
  }
}
EOF

  vector_schema {
    field_name = "text_embedding"
    dense_vector {
      dimensions = 768
      vertex_embedding_config {
        model_id   = "textembedding-gecko@003"
        task_type  = "RETRIEVAL_DOCUMENT"
        text_template = "Title: {title} ---- Plot: {plot}"
      }
    }
  }
}
