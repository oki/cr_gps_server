abstract class Handler
  @client : TCPSocket
  @channel : Channel::Unbuffered(GpsData)
  @done_channel : Channel::Unbuffered(Command)
  @device_id : String
  @name : String

  def initialize(@client, @channel, @done_channel)
    @device_id = ""
    @name = self.class.to_s.gsub("Protocols::", "").gsub("Handler", "")
  end

  def call
    handle_done_channel
    handle_messages
  end

  def handle_messages
    # abstract method
  end

  def handle_done_channel
    # data from parent
    spawn do
      begin
        message = @done_channel.receive
        puts "Message from done_channel: #{message}".colorize(:red)
        quit
      rescue Channel::ClosedError
        # ignore
      end
    end
  end

  def send_data(command : String, data : GpsData)
    unless @device_id.empty?
      @channel.send(data.merge({
        "command"   => command,
        "device_id" => @device_id,
        "name"      => @name,
      }))
    end
  end

  def quit
    unless @done_channel.closed?
      tmp_time = Time.now
      tmp_time_formatted = Time.now.to_s("%Y-%m-%d %H:%M:%S")

      puts "[#{tmp_time_formatted}] Disconnecting #{@device_id.colorize(:green)}"
      send_data("unregister", {"device_id" => @device_id})
      @done_channel.close
      @client.close
    end
  end
end
