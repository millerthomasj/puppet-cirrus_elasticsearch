# == Class cirrus_elasticsearch
#
# Includes the elasticsearch class from the elasticsearch/elasticsearch module.
#
# === Variables
#
# [* cirrus_elaticsearch::es_manage_repo *]
#   We use blobmaster to manage repostories this will always be false.
#
# [* cirrus_elaticsearch::es_recover_after_nodes *]
#   Ensure the cluster recovers once this number of nodes join.
#
# [* cirrus_elaticsearch::es_zen_minimum_master_nodes *]
#   Ensure at least this number masters exist before cluster goes green.
#
# [* cirrus_elaticsearch::es_zen_multicast_enabled *]
#   This should always be disabled as multicast should not be relied on for a production
#   system.
#
# [* cirrus_elaticsearch::es_number_of_replicas *]
#   How many replicas should the cluster maintain.
#
# [* cirrus_elaticsearch::es_number_of_shards *]
#   How many shards should be created per index by default.
#
# [* cirrus_elaticsearch::es_max_local_storage_nodes *]
#   How many storage nodes do we allow per data node.
#
# [* cirrus_elaticsearch::es_mlockall *]
#   Prevent elasticsearch from using swap space.
#
# [* cirrus_elaticsearch::es_destructive_requires_name *]
#   Deleting of indices must be done by name rather than by regex.
#
# === Hiera variables
#
# [* cirrus_elaticsearch::es_name *]
#   Name that will be appended to the hostname of the machine to identify the server in
#   the cluster.
#
# [* cirrus_elaticsearch::es_master0 *]
# [* cirrus_elaticsearch::es_master1 *]
# [* cirrus_elaticsearch::es_master2 *]
#   One of the primary masters for the elasticsearch cluster so we are able to shut off
#   multicast.
#
# [* cirrus_elaticsearch::es_node_master *]
#   Is this node a master node (true|false).
#
# [* cirrus_elaticsearch::es_node_data *]
#   Is this node a data node (true|false).
#
# [* cirrus_elaticsearch::es_clustername *]
#   Cluster name for the elasticsearch cluster.
#

class cirrus_elasticsearch (
  $es_name = $cirrus_elasticsearch::params::es_name,
  $es_master0 = $cirrus_elasticsearch::params::es_master0,
  $es_master1 = $cirrus_elasticsearch::params::es_master1,
  $es_master2 = $cirrus_elasticsearch::params::es_master2,
  $es_node_master = $cirrus_elasticsearch::params::es_node_master,
  $es_node_data = $cirrus_elasticsearch::params::es_node_data,
  $es_manage_repo = $cirrus_elasticsearch::params::es_manage_repo,
  $es_clustername = $cirrus_elasticsearch::params::es_clustername,
  $es_recover_after_nodes = $cirrus_elasticsearch::params::es_recover_after_nodes,
  $es_zen_minimum_master_nodes = $cirrus_elasticsearch::params::es_zen_minimum_master_nodes,
  $es_zen_multicast_enabled = $cirrus_elasticsearch::params::es_zen_multicast_enabled,
  $es_number_of_replicas = $cirrus_elasticsearch::params::es_number_of_replicas,
  $es_number_of_shards = $cirrus_elasticsearch::params::es_number_of_shards,
  $es_max_local_storage_nodes = $cirrus_elasticsearch::params::es_max_local_storage_nodes,
  $es_mlockall = $cirrus_elasticsearch::params::es_mlockall,
  $es_destructive_requires_name = $cirrus_elasticsearch::params::es_destructive_requires_name,
) inherits cirrus_elasticsearch::params
{
  include ::cirrus::repo::elasticsearch

  class { '::elasticsearch':
    ensure       => 'present',
    manage_repo  => $es_manage_repo,
    java_install => true,
    config       => { 'cluster.name'                       => $es_clustername,
                      'discovery.zen.minimum_master_nodes' => $es_zen_minimum_master_nodes,
                      'discovery.zen.multicast.enabled'    => $es_zen_multicast_enabled,
                      'discovery.zen.ping.unicast.hosts'   => [ $es_master0, $es_master1, $es_master2 ],
                      'gateway.recover_after_nodes'        => $es_recover_after_nodes,
                      'index.number_of_replicas'           => $es_number_of_replicas,
                      'index.number_of_shards'             => $es_number_of_shards,
                      'network.host'                       => '0.0.0.0',
                      'node.max_local_storage_nodes'       => $es_max_local_storage_nodes,
                      'action.destructive_requires_name'   => $es_destructive_requires_name,
                      'bootstrap.mlockall'                 => $es_mlockall,
    }
  }

  if $es_node_data {
    $es_blockdevs = $::blockdevices.split(',').delete('sr0').delete('vda')
    $es_datadirs = $es_blockdevs.map |$index, $device| { "/usr/share/elasticsearch/data${index}" }

    class { '::cirrus_elasticsearch::mount':
      blockdevs     => $es_blockdevs,
      instance_name => $es_name,
    }

    $heap = 0 + inline_template('<%= @memorysize_mb.to_i / 2000 %>')
    if $heap >= 30 {
      $set_heap = '31'
    }
    else {
      $set_heap = $heap
    }

    elasticsearch::instance { $es_name:
      init_defaults => {
        'ES_HEAP_SIZE' => "${set_heap}g",
      },
      datadir       => $es_datadirs,
      config        => {
        'node.master' => $es_node_master,
        'node.data'   => $es_node_data,
      }
    }
  }
  else {
    elasticsearch::instance { $es_name:
      config => {
        'node.master' => $es_node_master,
        'node.data'   => $es_node_data,
      }
    }
  }

  if $::elasticsearch_9200_num_data_nodes {
    $num_shards = $::elasticsearch_9200_num_data_nodes * 2
  }
  else {
    $num_shards = $es_number_of_shards
  }

  if $::elasticsearch_9200_cluster_status == 'green' {
    elasticsearch::template { 'set_index_shards':
      content => "{ \"template\":\"*\",\"order\":1,\"settings\":{\"number_of_shards\": $num_shards}}" # lint:ignore:variables_not_enclosed
    }

    include ::cirrus_elasticsearch::config
  }
}
