# == Class cirrus_elasticsearch
#
# Includes the elasticsearch class from the elasticsearch/elasticsearch module.
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

class cirrus_elasticsearch::backup (
  $es_swift_url          = undef,
  $es_swift_container    = undef,
  $es_swift_authmethod   = 'KEYSTONE',
  $es_swift_tenantname   = undef,
  $es_swift_username     = undef,
  $es_swift_password     = undef,
  $es_node_master        = $cirrus_elasticsearch::es_node_master,
)
{
  if ($es_node_master == true) and ($::cirrus_elasticsearch::xpack_install) {
    $elastic_username = 'admin'
    $elastic_password = $::cirrus_elasticsearch::xpack::users::admin_password

    cirrus_elasticsearch::settings { 'elk_backups':
      curl_args => "-u '${elastic_username}':'${elastic_password}'",
      content   => 'elk_backups.json.erb',
    }
  } elsif ($es_node_master == true) {
    cirrus_elasticsearch::settings { 'elk_backups':
      content => 'elk_backups.json.erb',
    }
  }
}
