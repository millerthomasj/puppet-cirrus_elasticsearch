class cirrus_elasticsearch::config (
)
{
  if $cirrus_logstash::client::filebeat_enabled {
    filebeat::prospector { "var_log_elasticsearch_${cirrus_elasticsearch::es_name}":
      doc_type => 'elasticsearch',
      paths    => [
        "/var/log/elasticsearch/${cirrus_elasticsearch::es_name}/${cirrus_elasticsearch::es_clustername}.log"
      ],
      fields   => {
        clustername => $cirrus_elasticsearch::es_clustername,
        tags        => [
          'es',
          $cirrus_elasticsearch::es_name,
        ]
      }
    }
  }
}
