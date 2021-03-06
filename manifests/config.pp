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
  $num_shards = query_nodes('cirrus_role=es and cirrus_app_instance=data').count()

  if $num_shards == 0 {
    $_num_shards = query_nodes('cirrus_role=elk').count()
  } else {
    $_num_shards = $num_shards
  }

  if $::elasticsearch_9200_name {
    es_instance_conn_validator { $es_name: }
    elasticsearch::template { 'set_index_shards':
      content => {
        'template' => '*',
        'order'    => 1,
        'settings' => {
          'number_of_shards' => $_num_shards,
        }
      },
      require => Es_Instance_Conn_Validator[$es_name],
    }
  }

  # Do the following only on es-master nodes for Elasticsearch index management
  if ( $es_node_master == true ) {
    # Install and configure curator
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
