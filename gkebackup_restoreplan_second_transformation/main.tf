resource "google_gke_backup_backup_plan" "basic" {
  name = "transform-rule-${local.name_suffix}"
  cluster = "projects/my-project-name/locations/us-east1/clusters/transform-rule-cluster-${local.name_suffix}"
  location = "us-east1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }
}

resource "google_gke_backup_restore_plan" "transform_rule" {
  name = "transform-rule-${local.name_suffix}-rp"
  description = "copy nginx env variables"
  labels = {
    "app" = "nginx"
  }
  location = "us-east1"
  backup_plan = google_gke_backup_backup_plan.basic.id
  cluster = "projects/my-project-name/locations/us-east1/clusters/transform-rule-cluster-${local.name_suffix}"
  restore_config {
    excluded_namespaces {
      namespaces = ["my-ns"]
    }
    namespaced_resource_restore_mode = "DELETE_AND_RESTORE"
    volume_data_restore_policy = "RESTORE_VOLUME_DATA_FROM_BACKUP"
    cluster_resource_restore_scope {
      excluded_group_kinds {
        resource_group = "apiextension.k8s.io"
        resource_kind = "CustomResourceDefinition"
      }
    }
    cluster_resource_conflict_policy = "USE_EXISTING_VERSION"
    transformation_rules {
      description = "Copy environment variables from the nginx container to the install init container."
      resource_filter {
        group_kinds {
          resource_kind = "Pod"
          resource_group = ""
        }
        json_path = ".metadata[?(@.name == 'nginx')]"
      }
      field_actions {
        op = "COPY"
        path = "/spec/initContainers/0/env"
        from_path = "/spec/containers/0/env"
      }
    }
  }
}
