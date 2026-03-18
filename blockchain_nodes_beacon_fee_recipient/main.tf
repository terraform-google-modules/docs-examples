resource "google_blockchain_node_engine_blockchain_nodes" "default_node_beacon_fee" {
  location = "us-central1"
  blockchain_type = "ETHEREUM"
  blockchain_node_id = "beacon_fee_node-${local.name_suffix}"
  ethereum_details {
    api_enable_admin = true
    api_enable_debug = true
    validator_config {
      beacon_fee_recipient = "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7"
    }
    node_type = "ARCHIVE"
    consensus_client = "LIGHTHOUSE"
    execution_client = "ERIGON"
    network = "MAINNET"
  }
  
  labels = {
    environment = "dev"
  }
}
