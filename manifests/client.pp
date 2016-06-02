class twc_elasticsearch::client (
  $es_node_master = false,
  $es_node_data = false,
)
{
  include twc_elasticsearch::common

  elasticsearch::instance { 'es_client':
    config => { 'node.master' => $es_node_master,
                'node.data'   => $es_node_data,
    }
  }
}
