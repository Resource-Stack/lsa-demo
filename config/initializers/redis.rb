# frozen_string_literal: true

#Redis.current = Redis.new(url:  ENV['REDIS_URL'],
#                          port: ENV['REDIS_PORT']
#                          db:   ENV['REDIS_DB'])

$redis = Redis::Namespace.new("lsa_Ruby", :redis => Redis.new)