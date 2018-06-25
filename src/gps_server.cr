require "socket"
require "./client"
require "./protocols/*"
require "./sidekiq_pusher"

enum Command
  Register
  Unregister
  GpsPosition
  Handshake
  Quit
end

require "dotenv"
require "redis"

Dotenv.load("/apps/tachobus/shared/.env")
Dotenv.load("/Users/oki/dev/work/tachobus/.env")

alias GpsProtocol = (Protocols::Tk103Client.class | Protocols::Gt06Client.class)

class GeneralServer
  def initialize
    @host = "0.0.0.0"
    @port = 5023
    @channels = [] of Channel(Command)
    @channel = Channel(Hash(String, String)).new
    @gps_protocols = Hash(UInt32, GpsProtocol).new

    # puts "Binding to port #{@host}:#{@port}"
    # @server = TCPServer.new(@host, @port)

    redis = Redis.new(host: ENV["REDIS_HOST"], port: ENV["REDIS_PORT"].to_i, database: ENV["REDIS_DB"].to_i)
    puts redis.url
    @sidekiq_pusher = SidekiqPusher.new(redis.url)

    if @sidekiq_pusher.ping
      puts "Redis OK (#{redis.url})"
    else
      puts "Problem with redis"
    end
    redis.close
  end

  def run
    setup_signals
    run_server
    setup_feedback_channel
  end

  def run_server
    @gps_protocols.each do |port, class_name|
      puts "Binding #{port} to #{class_name.to_s}"

      server = TCPServer.new(@host, port)

      n = 0
      spawn do
        loop do
          puts "Looping for #{class_name.to_s}"
          if client = server.accept?
            n += 1
            done_channel = Channel(Command).new
            @channels << done_channel

            spawn handle_client(class_name, client, @channel, done_channel)
          end
        end
      end
    end
  end

  def register_protocol(class_name : Class, port : UInt32)
    if @gps_protocols.has_key?(port)
      raise "Port #{port} already used for class #{@gps_protocols[port].to_s}"
    else
      @gps_protocols[port] = class_name
    end
  end

  def handle_client(client_class, client, channel, done_channel)
    # Client.new(client, channel, done_channel).call
    # Protocols::Tk103Client.new(client, channel, done_channel).call
    client_class.new(client, channel, done_channel).call
  end

  def setup_signals
    Signal::INT.trap do
      puts "SIGINT, exiting gracefully!"

      @channels.each do |channel|
        unless channel.closed?
          channel.send(Command::Quit)
        end
      end

      exit 0
    end
  end

  def setup_feedback_channel
    # data from clients
    # spawn do
    loop do
      puts "Feedback channel waiting for data..."
      data = @channel.receive

      puts "Reveived command: #{data["command"]}"

      case data["command"]
      when "register", "handshake"
        worker_class = "UpdateGpsDeviceStatusWorker"
        queue = "gps_devices"
        push_data = {
          "imei"         => data["device_id"],
          "status"       => "online",
          "last_seen_at" => Time.now.to_s,
        }
        @sidekiq_pusher.call(worker_class, queue, push_data)
      when "unregister"
        worker_class = "UpdateGpsDeviceStatusWorker"
        queue = "gps_devices"
        push_data = {
          "imei"   => data["device_id"],
          "status" => "offline",
        }
        @sidekiq_pusher.call(worker_class, queue, push_data)
      when "gps_position"
        worker_class = "PushGpsDeviceActivityWorker"
        queue = "gps_devices"
        push_data = {
          "imei"     => data["device_id"],
          "datetime" => data["date"],
          "lat"      => data["lat"],
          "lng"      => data["lng"],
          "speed"    => data["speed"],
        }

        @sidekiq_pusher.call(worker_class, queue, push_data)
      end
    end
    # end
  end
end
