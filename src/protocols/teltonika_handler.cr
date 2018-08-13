module Protocols
  class TeltonikaHandler < Handler
    def handle_messages
      puts "[Teltonika] Client connected!"

      500.times do |n|
        package_length = @device_id.empty? ? 17 : 8

        message = @client.gets(package_length)
        break if message.nil?

        tmp_time = Time.now
        tmp_time_formatted = Time.now.to_s("%Y-%m-%d %H:%M:%S")

        30.times {
          proto = Protocols::Teltonika.new(message.bytes)

          message_hex = StringUtils.bin_to_hex(message.bytes).join(" ")
          # puts "[I] [#{"Teltonika".colorize(:blue)}] [#{tmp_time_formatted}] #{proto.command_name} received data: #{message_hex}"
          # puts "[I] [#{"Debug".colorize(:red)}] correct package: #{proto.correct_package_size?}"

          if proto.correct_package_size?
            break
          end

          puts "[#{"DEBUG".colorize(:red)}] Reading rest #{proto.rest_size_to_read.colorize(:yellow)}"
          tmp_message = @client.gets(proto.rest_size_to_read)
          if tmp_message
            message += tmp_message
          end
        }

        proto = Protocols::Teltonika.new(message.bytes)
        message_hex = StringUtils.bin_to_hex(message.bytes).join(" ")
        puts "[#{"Teltonika".colorize(:blue)}] [#{tmp_time_formatted}] #{proto.command_name} received data: #{message_hex}"
        puts "[#{"Debug".colorize(:red)}] correct package: #{proto.correct_package_size?}"

        if proto.command_name == :unknown
          break
        end

        if proto.command_name == :avl_data
          puts "Expected avl_data_length: #{proto.avl_data_length}, current: #{message.size}"
        end

        if proto.command_name == :login
          @device_id = proto.device_id
          puts "device_id: #{@device_id.colorize(:green)}"

          send_data("handshake", {"device_id" => @device_id})
        elsif proto.command_name == :avl_data
          puts "Sending gps data"

          proto.gps_data.each do |gps_data|
            send_data("gps_position", gps_data)
          end

          proto.io_events.each do |io_event_data|
            pp io_event_data
            # send_data("gps_position", gps_data)
          end
        end

        response = proto.response
        puts "Response for #{proto.command_name}: #{response}"
        @client.write(response)
        @client.flush
      end
    rescue Errno
      puts "Errno error"
    ensure
      quit
    end
  end
end
