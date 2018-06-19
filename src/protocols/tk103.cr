module Protocols
  class Tk103
    @data : Array(UInt8)

    def initialize(@data)
      @data = data
    end

    def running_time
      as_string(@data[1..12])
    end

    def command_name
      case command
      when "BP05" # login
        :login
      when "BP00" # login
        :handshake
      when "BR00" # gps_position
        :gps_position
      else
        :unknown
      end
    end

    def command
      as_string(@data[13..16])
    end

    def device_id
      str = @data[17..31]
      if str.size > 5
        as_string(str)
      else
        nil
      end
    end

    def body
      case command_name
      when :login
        as_string(@data[32..91])
      when :gps_position
        as_string(@data[17..-4])
      end
    end

    def gps_data
      data = body

      unless data
        puts "Empty data"
        return nil
      end

      # Latitude
      lat = data[7..15].to_f / 100
      int_part = lat.to_i
      fixed_fraction_part = (((lat - int_part)/60)*100)
      lat = "%.6f" % (int_part + fixed_fraction_part)

      # Longitude
      lng = data[17..26].to_f / 100
      int_part = lng.to_i
      fixed_fraction_part = (((lng - int_part)/60)*100)
      lng = "%.6f" % (int_part + fixed_fraction_part)

      # Make Packet Time
      yy = ("20" + data[0..1]).to_i
      mm = data[2..3].to_i
      dd = data[4..5].to_i
      hh = data[33..34].to_i
      ii = data[35..36].to_i
      ss = data[37..38].to_i

      time = Time.utc(yy, mm, dd, hh, ii, ss).to_local.to_s
      # time = time.localtime("+02:00").to_s
      speed = data[28..33].to_f

      {
        date:  time,
        lat:   lat,
        lng:   lng,
        speed: speed,
      }
    end

    def response
      case command_name
      when :login
        login_response
      when :handshake
        handshake_response
      end
    end

    def login_response
      "(#{running_time}AP05)"
    end

    def handshake_response
      "(#{running_time}AP01HSO)"
    end

    private def as_string(bytes)
      bytes.map(&.chr).join
    end
  end
end
