class twc-elasticsearch::master (
  $es_node_master = true,
  $es_node_data = false,
)
{
  include twc-elasticsearch::common

  elasticsearch::instance { 'es_master':
    config => { 'node.master' => $es_node_master,
                'node.data'   => $es_node_data,
    }
}
