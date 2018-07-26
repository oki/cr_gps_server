module Protocols
  class Gt06Client < Client
    def handle_messages
      puts "[Gt06] Client connected!"

      200.times do |n|
        message = @client.gets([0x0d, 0x0a].map(&.chr).join)
        break if message.nil?

        tmp_time = Time.now
        tmp_time_formatted = Time.now.to_s("%Y-%m-%d %H:%M:%S")

        proto = Protocols::Gt06.new(message.bytes)

        message_hex = StringUtils.bin_to_hex(message.bytes).join(" ")

        puts "[#{"GT06".colorize(:blue)}] [#{tmp_time_formatted}] #{proto.protocol_number} received data: #{message_hex}"

        if proto.protocol_number == :unknown
          break
        end

        if proto.protocol_number == :login
          @device_id = proto.login_data["device_id"]
          puts "device_id: #{@device_id.colorize(:green)}"
        elsif proto.protocol_number == :location || proto.protocol_number == :alarm
          puts "device_id: #{@device_id.colorize(:green)}"

          pp proto.location_data

          if proto.protocol_number == :location
            puts "Sending gps data"
            send_data("gps_position", proto.location_data)
          end
        end

        if proto.protocol_number == :login || proto.protocol_number == :alarm || proto.protocol_number == :location || proto.protocol_number == :status_information
          response_package = proto.response
          # pp typeof(response_package)
          response_hex = response_package.map { |b| b.to_s(16).rjust(2, '0') }.join " "
          puts "response to #{proto.protocol_number}: #{response_hex}"
          @client.puts(response_package)
        end
      end
    rescue Errno
    ensure
      quit
    end
  end
end
