# Class cirrus_elasticsearch::xpack::users
#
# Install and configure Elasticsearch X-Pack
#

class cirrus_elasticsearch::xpack::users (
  $admin_password    = 'mypass',
  $logstash_username = 'logstash',
  $logstash_password = 'mypass',
  $kibana_username   = 'kibana',
  $kibana_password   = 'mypass',
)
{
  notify { 'update admin password': } ~>
  elasticsearch::shield::user { 'admin':
    password => $admin_password,
    roles    => ['admin'],
  }
  notify { 'update puppet password': } ~>
  elasticsearch::shield::user { $::cirrus_elasticsearch::shield_auth_username:
    password => $::cirrus_elasticsearch::shield_auth_password,
    roles    => ['admin'],
  }
  notify { 'update logstash password': } ~>
  elasticsearch::shield::user { $logstash_username:
    password => $logstash_password,
    roles    => ['logstash'],
  }
  notify { 'update kibana password': } ~>
  elasticsearch::shield::user { $kibana_username:
    password => $kibana_password,
    roles    => ['kibana4'],
  }
}
