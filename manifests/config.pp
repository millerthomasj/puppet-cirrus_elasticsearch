# Class cirrus_elasticsearch::config
#
# Configure Elasticsearch once the cluster has turned Green
#

class cirrus_elasticsearch::config (
  $es_clustername      = $::cirrus_elasticsearch::es_clustername,
  $es_name             = $::cirrus_elasticsearch::es_name,
  $es_number_of_shards = $::cirrus_elasticsearch::es_number_of_shards,
  $es_node_master      = $::cirrus_elasticsearch::es_node_master,
)
{
  if $::elasticsearch_9200_num_data_nodes {
    $num_shards = $::elasticsearch_9200_num_data_nodes * 2
  }
  else {
    $num_shards = $es_number_of_shards
  }

  elasticsearch::template { 'set_index_shards':
    content => "{ \"template\":\"*\",\"order\":1,\"settings\":{\"number_of_shards\": $num_shards}}" # lint:ignore:variables_not_enclosed
  }

  # Do the following only on es-master nodes for Elasticsearch index management
  if ( $es_node_master == true ) {
    include ::cirrus::repo::curator
    class { '::cirrus_curator':
      ensure      => 'latest',
      manage_repo => false,
    }

    Class[::cirrus::repo::curator] -> Class[::cirrus_curator]
  }

  if $cirrus_logstash::client::filebeat_enabled {
    filebeat::prospector { "var_log_elasticsearch_${es_name}":
      doc_type => 'elasticsearch',
      paths    => [
        "/var/log/elasticsearch/${es_name}/${es_clustername}.log"
      ],
      fields   => {
        clustername => $es_clustername,
        tags        => [
          'es',
          $es_name,
        ]
      }
    }
  }
}
