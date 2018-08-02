require "socket"
require "colorize"
require "./handler"
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

# :>
foo = [116_u8, 97_u8, 99_u8, 104_u8, 111_u8, 98_u8, 117_u8, 115_u8]
s_foo = foo.map(&.chr).join
Dotenv.load("/apps/#{s_foo}/shared/.env")
Dotenv.load("/Users/oki/dev/work/#{s_foo}/.env")
Colorize.enabled = true

alias GpsProtocol = (Protocols::Tk103Handler.class | Protocols::Gt06Handler.class | Protocols::TeltonikaHandler.class)

class GeneralServer
  @sidekiq_pusher : SidekiqPusher

  def initialize
    @host = "0.0.0.0"

    @channels = [] of Channel(Command)
    @channel = Channel(Hash(String, String)).new
    @gps_protocols = Hash(UInt32, GpsProtocol).new

    path = "debug_request_logs.json"
    @log_file = File.new(path, "a")

    @sidekiq_pusher = setup_sidekiq_pusher
  end

  def run
    setup_signals
    run_server
    setup_feedback_channel
  end

  def run_server
    @gps_protocols.each do |port, class_name|
      puts "Binding #{port} to #{class_name.to_s}".colorize(:blue)

      server = TCPServer.new(@host, port)

      n = 0
      spawn do
        loop do
          puts "Looping for #{class_name.to_s}".colorize(:blue)
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
    client_class.new(client, channel, done_channel).call
  end

  def setup_signals
    Signal::INT.trap do
      puts "SIGINT, exiting gracefully!".colorize(:red)

      @channels.each do |channel|
        unless channel.closed?
          channel.send(Command::Quit)
        end
      end

      1.upto(3) do |n|
        puts n.colorize(:yellow)
        sleep 0.5
      end

      exit 0
    end
  end

  def setup_sidekiq_pusher
    redis = Redis.new(host: ENV["REDIS_HOST"], port: ENV["REDIS_PORT"].to_i, database: ENV["REDIS_DB"].to_i)
    sidekiq_pusher = SidekiqPusher.new(redis.url)

    if sidekiq_pusher.ping
      puts "Redis OK (#{redis.url})".colorize(:blue)
    else
      raise "Problem with redis"
    end
    redis.close

    sidekiq_pusher
  end

  def setup_feedback_channel
    loop do
      puts "Feedback channel: waiting for data..."
      data = @channel.receive

      save_log(data)

      case data["command"]
      when "register", "handshake"
        puts "Reveived command: #{data["command"].colorize(:green)}"
        pp data
        worker_class = "UpdateGpsDeviceStatusWorker"
        queue = "gps_devices"
        push_data = {
          "imei"         => data["device_id"],
          "name"         => data["name"],
          "status"       => "online",
          "last_seen_at" => Time.now.to_s,
        }
        @sidekiq_pusher.call(worker_class, queue, push_data)
      when "unregister"
        puts "Reveived command: #{data["command"].colorize(:green)}"
        pp data
        worker_class = "UpdateGpsDeviceStatusWorker"
        queue = "gps_devices"
        push_data = {
          "imei"   => data["device_id"],
          "name"   => data["name"],
          "status" => "offline",
        }
        @sidekiq_pusher.call(worker_class, queue, push_data)
      when "gps_position"
        puts "#{data["command"].colorize(:magenta)} #{data["device_id"].colorize(:green)} #{data["lat"].colorize(:blue)} #{data["lng"].colorize(:blue)} #{data["speed"].colorize(:red)} km/h #{data["date"].colorize(:yellow)}"

        worker_class = "PushGpsDeviceActivityWorker"
        queue = "gps_devices"
        push_data = {
          "imei"     => data["device_id"],
          "datetime" => data["date"],
          "lat"      => data["lat"],
          "lng"      => data["lng"],
          "speed"    => data["speed"],
          "name"     => data["name"],
        }

        @sidekiq_pusher.call(worker_class, queue, push_data)
      else
        puts "Reveived command: #{data["command"].colorize(:green)}"
        pp data
      end

      puts "\n"
    end
  end

  def save_log(data)
    @log_file.puts (data.merge({"_ts" => Time.now.to_s})).to_json
    @log_file.flush
  end
end
