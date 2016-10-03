# Class cirrus_elasticsearch::xpack::roles
#
# Install and configure Elasticsearch X-Pack
#

class cirrus_elasticsearch::xpack::roles (
)
{
  resources { 'elasticsearch_shield_role':
    purge => false,
  }
  elasticsearch::shield::role { 'admin':
    privileges => {
      'cluster' => 'all',
      'indices' => {
        '*' => 'all',
      }
    }
  }
  elasticsearch::shield::role { 'user':
    privileges => {
      'indices' => {
        '*' => [
          'read',
        ]
      },
    }
  }
  elasticsearch::shield::role { 'anonymous':
    privileges => {
      'cluster' => [
        'monitor',
      ],
      'indices' => {
        '*' => [
          'monitor',
        ]
      },
    }
  }
  elasticsearch::shield::role { 'logstash':
    privileges => {
      'cluster' => [
        'indices:admin/template/get',
        'indices:admin/template/put',
        'cluster:monitor/nodes/info',
      ],
      'indices' => {
        'logstash-*' => [
          'indices:data/write/bulk',
          'indices:data/write/delete',
          'indices:data/write/update',
          'indices:data/read/search',
          'indices:data/read/scroll',
          'create_index',
        ]
      },
    }
  }
  elasticsearch::shield::role { 'kibana4':
    privileges => {
      'cluster' => [ 'monitor' ],
      'indices' => {
        '.kibana' => [ 'all' ],
      },
    }
  }
}
