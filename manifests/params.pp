# Class cirrus_elasticsearch::params
#
# Default configuration for cirrus_elasticsearch module
#

class cirrus_elasticsearch::params
{
  $es_name = 'undef'
  $es_master0 = '10.10.0.100'
  $es_master1 = '10.10.0.101'
  $es_master2 = '10.10.0.102'

  $es_node_master = false
  $es_node_data = false

  $es_manage_repo = false

  $es_clustername = 'myElkCluster'
  $es_recover_after_nodes = '2'
  $es_zen_minimum_master_nodes = '2'
  $es_zen_multicast_enabled = false

  $es_number_of_replicas = '1'
  $es_number_of_shards = '10'
  $es_max_local_storage_nodes = '1'
  $es_mlockall = true

  $es_destructive_requires_name = true
}
