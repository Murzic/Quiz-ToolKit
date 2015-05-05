Resque.redis = Redis.new(:host => '127.0.0.1', :port => 6379)
# `COUNT=5 QUEUE=* rake environment resque:work`