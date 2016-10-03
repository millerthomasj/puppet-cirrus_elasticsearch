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
#  elasticsearch::plugin { 'elasticsearch/marvel-agent/latest': }

  include ::cirrus_elasticsearch::xpack::users
  include ::cirrus_elasticsearch::xpack::roles
}
