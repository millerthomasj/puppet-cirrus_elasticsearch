# Class cirrus_elasticsearch::xpack
#
# Install and configure Elasticsearch X-Pack
#

class cirrus_elasticsearch::xpack (
  $es_name,
)
{
  Elasticsearch::Plugin { instances => [$es_name], }
  elasticsearch::plugin { 'elasticsearch/license/latest': }
  elasticsearch::plugin { 'elasticsearch/shield/latest': }
  elasticsearch::plugin { 'marvel-agent':
    url => 'https://download.elastic.co/elasticsearch/release/org/elasticsearch/plugin/marvel-agent/2.3.3/marvel-agent-2.3.3.zip',
  }
  elasticsearch::plugin { 'elasticsearch/watcher/latest': }

  include ::cirrus_elasticsearch::xpack::users
  include ::cirrus_elasticsearch::xpack::roles
}
