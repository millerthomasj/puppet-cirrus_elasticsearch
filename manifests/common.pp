class twc-elasticsearch::common (
  $es_package_url = 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.2.deb',
  $es_clustername = 'elk-cluster',
  $es_master0 = '10.10.0.100',
  $es_master1 = '10.10.0.101',
  $es_master2 = '10.10.0.102',
  $es_zen_minimum_master_nodes = '2',
  $es_zen_multicast_enabled = false,
  $es_recover_after_nodes = '2',
  $es_number_of_replicas = '1',
  $es_number_of_shards = '10',
  $es_max_local_storage_nodes = '1',
  $es_destructive_requires_name = true,
  $es_mlockall = true
)
{
  class { 'elasticsearch':
    ensure           => 'present',
    package_url      => $es_package_url,
    java_install     => true,
    config => { 'cluster.name'                       => $es_clustername,
                'discovery.zen.minimum_master_nodes' => $es_zen_minimum_master_nodes,
                'discovery.zen.multicast.enabled'    => $es_zen_multicast_enabled,
                'discovery.zen.ping.unicast.hosts'   => [ $es_master0, $es_master1, $es_master2 ],
                'gateway.recover_after_nodes'        => $es_recover_after_nodes,
                'index.number_of_replicas'           => $es_number_of_replicas,
                'index.number_of_shards'             => $es_number_of_shards,
                'network.host'                       => $::ipaddress,
                'node.max_local_storage_nodes'       => $es_max_local_storage_nodes,
                'action.destructive_requires_name'   => $es_destructive_requires_name,
                'bootstrap.mlockall'                 => $es_mlockall,
  },
}
