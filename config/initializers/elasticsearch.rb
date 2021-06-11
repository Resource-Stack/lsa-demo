#http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=500
=begin
config = {
  host: "http://dev15.resourcestack.com:9200/",
  transport_options: {
    request: { timeout: 5 }
  }
}

if File.exists?("config/elasticsearch.yml")
  config.merge!(YAML.load_file("config/elasticsearch.yml")[Rails.env].deep_symbolize_keys)
end

Elasticsearch::Model.client = Elasticsearch::Client.new(config)


#https://www.youtube.com/watch?v=_kqunm8w7GI
=end

