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
          end
        end
      rescue
      end
    end
  end
end

EsHealth.run
