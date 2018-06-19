class Client
  @client : TCPSocket
  @channel : Channel::Unbuffered(Hash(String, String))
  @done_channel : Channel::Unbuffered(Command)

  def initialize(@client, @channel, @done_channel, @device_id : Int32); end

  def call
    handle_done_channel
    handle_messages
  end

  def handle_messages
    puts "Client connected! ( #{@device_id} )"
    @client.puts "hello"
    # @channel.send({"command" => "register", "device_id" => @device_id.to_s})

    200.times do |n|
      message = @client.gets(")")
      break if message.nil?
      puts message
      @client.puts "OK :)"
      @channel.send({"one" => "1", "two" => "2"})
    end

    quit
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

  def quit
    puts "Quiting client"
    puts "Client disconnected"
    @channel.send({"command" => "unregister", "device_id" => @device_id.to_s})
    @done_channel.close
  end
end
