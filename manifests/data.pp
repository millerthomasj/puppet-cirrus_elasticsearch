class twc-elasticsearch::data (
  $es_node_master = false,
  $es_node_data = true,
)
{
  include twc-elasticsearch::common

  elasticsearch::instance { 'es_data':
    config => { 'node.master' => $es_node_master,
                'node.data'   => $es_node_data,
    }
}
