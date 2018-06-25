module Protocols
  class Tk103Client < Client
    def handle_messages
      puts "Client connected! ( #{@device_id} )"
      # @client.puts "hello"
      # @channel.send({"command" => "register", "device_id" => @device_id.to_s})

      200.times do |n|
        message = @client.gets(")")
        break if message.nil?

        tmp_time = Time.now
        tmp_time_formatted = Time.now.to_s("%Y-%m-%d %H:%M:%S")
        proto = Protocols::Tk103.new(message.bytes)

        # message_hex = StringUtils.bin_to_hex(message).join(" ")
        puts "[#{tmp_time_formatted}] #{proto.command_name} received data: #{message}"
        puts proto.response

        if proto.command_name == :login || proto.command_name == :handshake
          @device_id = @device_id.empty? ? proto.device_id.to_s : @device_id

          if proto.gps_data && !proto.gps_data.empty?
            send_data("gps_position", proto.gps_data)
          else
            send_data("handshake", {"device_id" => @device_id})
          end
        end

        if proto.command_name == :gps_position
          send_data("gps_position", proto.gps_data)
        end

        if @device_id.empty?
          puts "device_id: unknown"
        else
          puts "device_id: #{@device_id}"
        end
        # puts "received hex data: #{message_hex}"
      end
    rescue Errno
    ensure
      quit
    end
  end
end
