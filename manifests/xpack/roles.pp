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
  elasticsearch::shield::role { 'kibana4_user':
    mappings   => [
      # Tom Miller
      'CN=V636426,OU=Vendors,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Jason Rouault
      'CN=E203392,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Nathan Randall
      'CN=V606454,OU=Vendors,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Matt Fischer
      'CN=E197501,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Clayton O'Neill
      'CN=E057457,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Al Straub
      'CN=E042775,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Brad Klein
      'CN=E211308,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Carlos Konstanski
      'CN=E242100,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Craig Delatte
      'CN=E056388,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Darren Kara
      'CN=E161927,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Franciraldo Cavalcante
      'CN=V614543,OU=Vendors,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Kevin Kirkpatrick
      'CN=E143853,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Kim Jensen
      'CN=E213380,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Patrick Ocana
      'CN=V605989,OU=Vendors,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Ryan Bak
      'CN=E203731,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Shridhar Ramireddy
      'CN=E079663,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Yan Ning
      'CN=E221820,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # David Medberry
      'CN=E200371,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Steven Travis
      'CN=E219772,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Adam Vinsh
      'CN=E211310,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Bryan Stillwell
      'CN=E216751,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Sean Lynn
      'CN=E180970,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Bo Quan
      'CN=E217323,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Eric Peterson
      'CN=E211309,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Michael Foster
      'CN=V633983,OU=Vendors,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Ryan Ackley
      'CN=V620744,OU=Vendors,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
    ],
    privileges => {
      'cluster' => [ 'monitor' ],
      'indices' => {
        'logstash-*' => [
          'view_index_metadata',
          'read',
        ],
        '.kibana*'   => [
          'manage',
          'read',
          'index',
        ],
      },
    }
  }
  elasticsearch::shield::role { 'marvel_user':
    mappings   => [
      # Tom Miller
      'CN=V636426,OU=Vendors,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Nathan Randall
      'CN=V606454,OU=Vendors,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Jason Rouault
      'CN=E203392,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Steven Travis
      'CN=E219772,OU=Users,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
      # Patrick Ocana
      'CN=V605989,OU=Vendors,OU=Mystro,OU=TWC Divisions,DC=corp,DC=twcable,DC=com',
    ],
    privileges => {
      'indices' => {
        '.marvel-es-*' => [
          'read',
        ],
        '.kibana'      => [
          'view_index_metadata',
          'read',
        ],
      },
    }
  }
  elasticsearch::shield::role { 'kibana4_server':
    privileges => {
      'cluster' => [ 'monitor' ],
      'indices' => {
        '.kibana' => [
          'all',
        ],
      },
    }
  }
}
