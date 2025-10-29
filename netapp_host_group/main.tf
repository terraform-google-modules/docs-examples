resource "google_netapp_host_group" "test_host_group" {
  name = "test-host-group-${local.name_suffix}"
  location = "us-central1"
  os_type = "LINUX"
  type = "ISCSI_INITIATOR"
  hosts = ["iqn.1994-05.com.redhat:8518f79d5366"]
}
