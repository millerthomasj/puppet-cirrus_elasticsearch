# == Class cirrus_elasticsearch::backup
#

class cirrus_elasticsearch::backup (
  $es_swift_url          = hiera('keystone::endpoint::public_url'),
  $es_swift_container    = "elk_backups-${::cirrus_site_iteration}",
  $es_swift_authmethod   = 'KEYSTONE',
  $es_swift_tenantname   = 'elastic-stack',
  $es_swift_username     = 'elk_backup',
  $es_swift_password     = undef,
  $es_node_master        = $cirrus_elasticsearch::es_node_master,
)
{
  if 'swift-repository' in $::elasticsearch_9200_plugins {
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
}
