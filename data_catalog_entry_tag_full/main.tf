resource "google_data_catalog_entry" "entry" {
  entry_group = google_data_catalog_entry_group.entry_group.id
  entry_id = "my_entry-${local.name_suffix}"

  user_specified_type = "my_custom_type"
  user_specified_system = "SomethingExternal"

  schema = <<EOF
{
  "columns": [
    {
      "column": "first_name",
      "description": "First name",
      "mode": "REQUIRED",
      "type": "STRING"
    },
    {
      "column": "last_name",
      "description": "Last name",
      "mode": "REQUIRED",
      "type": "STRING"
    },
    {
      "column": "address",
      "description": "Address",
      "mode": "REPEATED",
      "subcolumns": [
        {
          "column": "city",
          "description": "City",
          "mode": "NULLABLE",
          "type": "STRING"
        },
        {
          "column": "state",
          "description": "State",
          "mode": "NULLABLE",
          "type": "STRING"
        }
      ],
      "type": "RECORD"
    }
  ]
}
EOF
}

resource "google_data_catalog_entry_group" "entry_group" {
  entry_group_id = "my_entry_group-${local.name_suffix}"
}

resource "google_data_catalog_tag_template" "tag_template" {
  tag_template_id = "my_template-${local.name_suffix}"
  region = "us-central1"
  display_name = "Demo Tag Template"

  fields {
    field_id = "source"
    display_name = "Source of data asset"
    type {
      primitive_type = "STRING"
    }
    is_required = true
  }

  fields {
    field_id = "num_rows"
    display_name = "Number of rows in the data asset"
    type {
      primitive_type = "DOUBLE"
    }
  }

  fields {
    field_id = "pii_type"
    display_name = "PII type"
    type {
      enum_type {
        allowed_values {
          display_name = "EMAIL"
        }
        allowed_values {
          display_name = "SOCIAL SECURITY NUMBER"
        }
        allowed_values {
          display_name = "NONE"
        }
      }
    }
  }

  force_delete = "true"
}

resource "google_data_catalog_tag" "basic_tag" {
  parent   = google_data_catalog_entry.entry.id
  template = google_data_catalog_tag_template.tag_template.id

  fields {
    field_name   = "source"
    string_value = "my-string"
  }

  fields {
    field_name   = "num_rows"
    double_value = 5
  }

  fields {
    field_name = "pii_type"
    enum_value = "EMAIL"
  }

  column = "address"
}

resource "google_data_catalog_tag" "second-tag" {
  parent   = google_data_catalog_entry.entry.id
  template = google_data_catalog_tag_template.tag_template.id

  fields {
    field_name   = "source"
    string_value = "my-string"
  }

  fields {
    field_name = "pii_type"
    enum_value = "NONE"
  }

  column = "first_name"
}
