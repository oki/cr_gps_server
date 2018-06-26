module Protocols
  class Gt06
    @data : Array(UInt8)

    def initialize(@data)
      @data = data
    end

    def packet_length
      @data[2]
    end

    def protocol_number_raw
      @data[3]
    end

    def protocol_number
      case @data[3]
      when 0x01.chr
        :login
      when 0x12.chr
        :location
      when 0x13.chr
        :status_information
      when 0x15.chr
        :string_information
      when 0x16.chr
        :alarm
      when 0x1A.chr
        :gps_query
      when 0x80.chr
        :command
      else
        :unknown
      end
    end

    def content
      offset = packet_length - 2
      @data[4..offset]
    end

    def content_for_checksum
      @data[2..packet_length]
    end

    def serial_number
      @data[-6..-5]
    end

    def checksum
      @data[-4..-3]
    end

    def response
      case protocol_number
      when :login, :alarm, :location, :status_information
        universal_response
      else
        "Unknown"
      end
    end

    def data
      case protocol_number
      when :login
        login_data
      when :location
        location_data
      when :alarm
        # alarm_data
        location_data
      when :status_information
        # status_information_data
      else
        # raise "Unknown data"
        return {} of String => String
      end
    end

    def login_data
      device_id = content.map { |b| b.to_s(16).rjust(2, '0') }.join.gsub(/^0/, "")
      {
        "device_id" => device_id,
      }
    end

    def location_data
      # 78 78 1f 12
      # 12 05 15 15 1d 2f
      # c0 05 60 0c 13 02 24 57 6d 00 04 00 01 04 03 ce 4c 00 0f dd 00 5b 5d ef 0d 0a
      # 78 78 - start
      # 1f - len
      # 12 - type
      # 12 05 15 11 24 2c - data
      date = content[0..5]

      # puts
      # puts StringUtils.bin_to_hex(date).join(" ")
      # puts

      # pp date
      # pp typeof(date)

      year, month, day, hour, min, sec = date.map { |b| b.to_s(10).to_i }
      year = year.to_i + 2000
      date = "#{year}-#{month}-#{day} #{hour}:#{min}:#{sec}"

      time = Time.utc(year, month, day, hour, min, sec).to_local.to_s

      # pp time

      # c0 - satelites
      # 05 60 0a 93 - lat

      lat = content[7..11]
      lat = "%.6f" % (content[7..10].map { |b| b.to_s(16).rjust(2, '0') }.join.to_i64(16).to_i / 30_000.0 / 60.0).to_f
      lng = "%.6f" % (content[11..14].map { |b| b.to_s(16).rjust(2, '0') }.join.to_i64(16).to_i / 30_000.0 / 60.0).to_f
      # pp lat
      # pp lng

      # lng = content[11..14].each_byte.map { |b| b.to_s(10).rjust(2, "0") }.join
      # 02 24 55 03 - lng
      # 01 - speed

      speed = content[15].to_s

      # puts "Course1: "
      # puts StringUtils.bin_to_hex(content[16])
      # puts

      course1 = content[16]
      course2 = content[17]
      # puts "Course: #{course1}"
      # puts "Course: #{course2}"

      gps_realtime = 0b1000
      gps_positioned = 0b0100
      gps_east = 0b0010
      gps_north = 0b0001

      gps_info_realtime = (course1 & gps_realtime) != 0
      gps_info_positioned = (course1 & gps_positioned) != 0

      # 04 00 - course, status
      # 01 04 - MCC
      # 03 - MNC
      # ce 4c - LAC
      # 00 0d 17 - Cell ID
      # 00 9c - serial
      # 7c a9 - check sum
      # 0d 0a - end

      {
        "date"  => time,
        "lat"   => lat,
        "lng"   => lng,
        "speed" => speed,
        # "gps_positioned" => gps_info_positioned,
        # "gps_realtime"   => gps_info_realtime,
      }
    end

    def valid?
      crc = CrcItu.crc(content_for_checksum)
      crc.to_s(16) == checksum.map { |n| n.to_s(16).rjust(2, '0') }.join
    end

    # God, please.
    # TODO: Rewrite this shit.
    def universal_response
      package = [
        0x78_u8, 0x78_u8,    # start
        5_u8,                # len
        protocol_number_raw, # protocol number
      ]
      package << serial_number[0]
      package << serial_number[1]

      crc2_hex_str = CrcItu.crc(package[2..-1])
      crc_arr = crc2_hex_str.to_s(16).rjust(4, '0').scan(/../).map { |md| md[0].to_u8(16).to_u8 }
      package << crc_arr[0]
      package << crc_arr[1]

      package << 0x0D
      package << 0x0A

      package

      # package.map(&.chr).map(&.ord)
    end
  end
end
