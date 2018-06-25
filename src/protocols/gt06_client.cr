module Protocols
  class Gt06Client < Client
    def handle_messages
      puts "Client connected! ( #{@device_id} )"

      quit
    end
  end
end
