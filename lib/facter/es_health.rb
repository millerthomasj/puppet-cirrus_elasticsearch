require 'net/http'
require 'json'
require 'yaml'

module EsHealth
  def self.add_fact(prefix, key, value)
    key = "#{prefix}_#{key}".to_sym
    ::Facter.add(key) do
      setcode { value }
    end
  end

  def self.run
    dir_prefix = '/etc/elasticsearch'
    ports = []

    if File.directory?(dir_prefix)
      Dir.foreach(dir_prefix) { |dir|
        next if dir == '.'

        if File.exists?("#{dir_prefix}/#{dir}/elasticsearch.yml")
          config_data = YAML.load_file("#{dir_prefix}/#{dir}/elasticsearch.yml")
          unless config_data['http'].nil?
            next if config_data['http']['enabled'] == 'false'

            if config_data['http']['port'].nil?
              port = "9200"
            else
              port = config_data['http']['port']
            end
          else
            port = "9200"
          end
          ports << port
        end
      }

      begin
        if ports.count > 0
          ports.each do |port|
            key_prefix = "elasticsearch_#{port}"

            uri = URI("http://localhost:#{port}")
            http = Net::HTTP.new(uri.host, uri.port)
            http.read_timeout = 10
            response = http.get("/")
            json_data = JSON.parse(response.body)
            next if json_data['status'] && json_data['status'] != 200

            uri2 = URI("http://localhost:#{port}/_cluster/health")
            http2 = Net::HTTP.new(uri2.host, uri2.port)
            http2.read_timeout = 10
            response2 = http2.get(uri2.path)
            json_data_node = JSON.parse(response2.body)

            add_fact(key_prefix, 'cluster_status', json_data_node['status'])
            add_fact(key_prefix, 'num_data_nodes', json_data_node['number_of_data_nodes'])

            uri3 = URI("http://localhost:#{port}/_nodes/#{json_data['name']}")
            http3 = Net::HTTP.new(uri3.host, uri3.port)
            http3.read_timeout = 10
            response3 = http3.get(uri3.path)
            json_data_localnode = JSON.parse(response3.body)

            uri4 = URI("http://localhost:#{port}/_cluster/state/master_node")
            http4 = Net::HTTP::new(uri4.host, uri4.port)
            http4.read_timeout = 10
            response4 = http4.get(uri4.path)
            json_data_masternode = JSON.parse(response4.body)

            if json_data_localnode['nodes'].first[0] == json_data_masternode['master_node']
              add_fact(key_prefix, 'master_node', 'true')
            else
              add_fact(key_prefix, 'master_node', 'false')
            end
          end
        end
      rescue
      end
    end
  end
end

EsHealth.run
