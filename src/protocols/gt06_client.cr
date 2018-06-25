module Protocols
  class Gt06Client < Client
    def handle_messages
      puts "Client connected! ( #{@device_id} )"

      quit

      # 200.times do |n|
      #   message = @client.gets(")")
      #   break if message.nil?
    end
  end
end
