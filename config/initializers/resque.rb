require 'resque/server'
require 'resque/failure/multiple'
require 'resque/failure/redis'

#Dir[Rails.root.join("app", "jobs", "*.rb")].each { |file| require file }

  uri = URI.parse(ENV['REDISTOGO_URL'])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

  Resque.redis = REDIS
  Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds


Resque::Failure::Multiple.classes = [Resque::Failure::Redis]
Resque::Failure.backend = Resque::Failure::Multiple
