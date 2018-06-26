require "json"

class SidekiqPusher
  def initialize(redis_url : String)
    @redis = Redis.new(url: redis_url)
  end

  def call(worker_class : String, queue : String, data : Hash(String, String))
    puts "[sidekiq_pusher] Pushing data to redis"

    msg = {
      "class"       => worker_class,
      "queue"       => queue,
      "args"        => [data],
      "retry"       => true,
      "jid"         => Random::Secure.hex(12),
      "created_at"  => Time.now.to_s,
      "enqueued_at" => Time.now.to_s,
    }

    @redis.lpush("queue:#{queue}", msg.to_json)
    @redis.sadd("queues", queue)
    puts "[sidekiq_pusher] Done."
  end

  def ping
    @redis.ping == "PONG"
  end

  def clean
    @redis.close
  end
end
