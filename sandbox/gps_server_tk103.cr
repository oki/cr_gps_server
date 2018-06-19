require "socket"

require "./client"

enum Command
  Register
  Unregister
  Quit
end

host = "0.0.0.0"
port = 5023

channel = Channel(Hash(String, String)).new
puts "Binding to port #{host}:#{port}"
server = TCPServer.new(host, port)

def handle_client(client, channel, done_channel)
  spawn do
    message = done_channel.receive
    puts "message from done_channel: #{message}"

    client.close
  end

  puts "Client connected!"
  client.puts "hello"

  200.times do |n|
    message = client.gets(")")
    break if message.nil?
    puts message
    client.puts "OK :)"
    channel.send({"one" => "1", "two" => "2"})
  end
  puts "Client disconnected"
  client.close
  channel.send({"command" => "quit"})
end

def handle_client2(client, channel, done_channel, n)
  Client.new(client, channel, done_channel, n).call
end

devices = {} of String => Bool
channels = [] of Channel(Command)

# data from clients
spawn do
  loop do
    data = channel.receive

    pp data["command"]

    case data["command"]
    when "unregister"
      puts data["device_id"]
    when "register"
      puts data["device_id"]
    end
  end
end

Signal::INT.trap do
  puts "SIGINT, exiting gracefully!"

  channels.each do |channel|
    unless channel.closed?
      # puts "Channel closed - skipped"
      # else
      channel.send(Command::Quit)
    end
  end

  exit 0
end

n = 0
loop do
  if client = server.accept?
    n += 1
    done_channel = Channel(Command).new
    channels << done_channel

    spawn handle_client2(client, channel, done_channel, n)
    # spawn Client.new(client, channel, done_channel)
  end
end
