abstract class Client
  @client : TCPSocket
  @channel : Channel::Unbuffered(Hash(String, String))
  @done_channel : Channel::Unbuffered(Command)
  @device_id : String

  def initialize(@client, @channel, @done_channel)
    @device_id = ""
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
        puts "message from done_channel: #{message}"
        quit
      rescue Channel::ClosedError
        # ignore
      end
    end
  end

  def send_data(command : String, data : Hash(String, String))
    unless @device_id.empty?
      @channel.send(data.merge({
        "command"   => command,
        "device_id" => @device_id,
      }))
    end
  end

  def quit
    puts "Quiting client"
    puts "Client disconnected"
    send_data("unregister", {"device_id" => @device_id})
    @done_channel.close
    @client.close
  end
end
