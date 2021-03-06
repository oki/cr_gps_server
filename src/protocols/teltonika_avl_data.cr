module Protocols
  class TeltonikaAvlData
    @data : Array(UInt8)
    @avl_data_count : Int32

    def initialize(@data)
      @data = data
      @avl_data_count = extract_int(1).to_i
      @debug = false

      @events = [] of GpsData
      @gps_data = [] of GpsData
    end

    def parse_package
      if @gps_data.size > 0
        return
      end

      @avl_data_count.times do |n|
        debug "#{n}"
        event_data = {} of String => String

        # gps data
        date = Time.epoch_ms(extract_int(8)).to_local.to_s
        debug "date: #{date}"

        priority = extract_int(1)
        debug "priority: #{priority}"

        raw_lng = extract_signed_int(4)

        lng = "%.6f" % (raw_lng / 100_00_000.0)
        debug "raw_lng: #{raw_lng}"
        debug "lng: #{lng}"

        raw_lat = extract_signed_int(4)

        lat = "%.6f" % (raw_lat / 100_00_000.0)
        debug "raw_lat: #{raw_lat}"
        debug "lat: #{lat}"

        altitude = extract_int(2)
        debug "altitude: #{altitude}"

        angle = extract_int(2)
        debug "angle: #{angle}"

        satelites = extract_int(1)
        debug "satelites: #{satelites}"

        speed = extract_int(2).to_s
        debug "speed: #{speed}"

        @gps_data.push({
          "date"  => date,
          "lat"   => lat,
          "lng"   => lng,
          "speed" => speed,
        })

        # I/O Elements
        event_id = extract_int(1)
        debug "Main event: #{event_name(event_id)}"

        element_count = extract_int(1)
        debug "element_count: #{element_count}"

        element_count_1b = extract_int(1)
        debug "element_count_1b: #{element_count_1b}"

        event_data = {
          "date"       => date,
          "event_name" => event_name(event_id).to_s,
        }

        # take(element_count_1b * 2)
        element_count_1b.times do |m|
          element_1b_id = extract_int(1)
          element_1b_value = extract_int(1)
          event_name = event_name(element_1b_id)
          debug "  #{event_name}: #{element_1b_value}"
          event_data[event_name.to_s] = element_1b_value.to_s
        end

        element_count_2b = extract_int(1)
        debug "element_count_2b: #{element_count_2b}"
        # take(element_count_2b * 3)
        element_count_2b.times do |m|
          element_2b_id = extract_int(1)
          event_name = event_name(element_2b_id)
          element_2b_value = extract_int(2)
          debug "  #{event_name}: #{element_2b_value}"
          event_data[event_name.to_s] = element_2b_value.to_s
        end

        element_count_4b = extract_int(1)
        debug "element_count_4b: #{element_count_4b}"
        # take(element_count_4b * 5)
        element_count_4b.times do |m|
          element_4b_id = extract_int(1)
          element_4b_value = extract_int(4)
          event_name = event_name(element_4b_id)
          debug "  #{event_name}: #{element_4b_value}"
          event_data[event_name.to_s] = element_4b_value.to_s
        end

        element_count_8b = extract_int(1)
        debug "element_count_8b: #{element_count_8b}"
        # take(element_count_8b * 9)
        element_count_8b.times do |m|
          element_8b_id = extract_int(1)
          element_8b_value = extract_int(8)
          event_name = event_name(element_8b_id)
          debug "  #{event_name}: #{element_8b_value}"
          event_data[event_name.to_s] = element_8b_value.to_s
        end

        prepare_iccid(event_data)

        @events.push(event_data)
      end
    end

    def gps_data
      parse_package
      @gps_data
    end

    def io_events
      parse_package
      @events
    end

    private def extract_int(len)
      take(len).map { |h| h.to_s(16).rjust(2, '0') }.join.to_i64(16, prefix: false)
    end

    private def extract_signed_int(len)
      arr = take(len).map { |h| h.to_s(16).rjust(2, '0') }
      value = arr.join.to_i64(16, prefix: false)

      if ((value & 0xF0000000) >> 28) == 0xF
        value - 0x100000000
      else
        value
      end
    end

    private def take(len)
      @data.shift(len)
    end

    private def debug(str)
      if @debug
        puts str
      end
    end

    private def prepare_iccid(event_data)
      if event_data.has_key?("sim_iccid1_number") && event_data.has_key?("sim_iccid2_number")
        sim_iccid1_number_len = event_data["sim_iccid1_number"].size
        sim_iccid2_number_len = event_data["sim_iccid2_number"].size

        add_zeros = ""

        if sim_iccid2_number_len < 10
          add_zeros = "0" * (10 - sim_iccid2_number_len)
        end

        event_data["sim_iccid"] = [
          event_data["sim_iccid1_number"],
          add_zeros,
          event_data["sim_iccid2_number"],
        ].join
      end
    end

    private def event_name(event_id)
      case event_id
      when 239
        :ignition
      when 240
        :movement
      when 200
        :sleep_mode
      when 80
        :data_mode
      when 21
        :gsm_signal_strength
      when 69
        :gnss_status
      when 181
        :pdop
      when 182
        :hdop
      when 66
        :ext_voltage
      when 24
        :speed
      when 205
        :gsm_cell_id
      when 206
        :gsm_area_code
      when 67
        :battery_voltage
      when 68
        :battery_current
      when 241
        :gsm_operator
      when 199
        :trip_odometer
      when 16
        :total_odometer
      when 1
        :din_1
      when 12
        :fuel_used_gps
      when 13
        :average_fuel_use
      when 17
        :accelerometer_x
      when 18
        :accelerometer_y
      when 19
        :accelerometer_z
      when 11
        :sim_iccid1_number
      when 14
        :sim_iccid2_number
      when 10
        :sd_status
      when 15
        :eco_score
      when 238
        :user_id
      when 250
        :trip_event
      when 255
        :overspeeding_event
      when 251
        :idling_event
      when 253
        :green_driving_type
      when 254
        :green_driving_value
      when 243
        :green_driving_event_duration
      when 246
        :towing_detection_event
      when 252
        :unplug_event
      when 247
        :crash_detection
      when 249
        :jamming_detection
      else
        "unknown: #{event_id}"
      end
    end
  end
end
