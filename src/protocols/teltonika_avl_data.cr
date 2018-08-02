module Protocols
  class TeltonikaAvlData
    @data : Array(UInt8)
    @avl_data_count : Int32

    def initialize(@data)
      @data = data
      @avl_data_count = extract_int(1).to_i
      @debug = false
    end

    def data
      debug typeof(@data)

      result = [] of Hash(String, String)

      @avl_data_count.times do |n|
        debug "#{n}"

        # gps data
        date = Time.epoch_ms(extract_int(8)).to_local.to_s
        debug "date: #{date}"

        priority = extract_int(1)
        debug "priority: #{priority}"

        lng = "%.6f" % (extract_int(4) / 100_00_000.0)
        debug "lng: #{lng}"

        lat = "%.6f" % (extract_int(4) / 100_00_000.0)
        debug "lat: #{lat}"

        altitude = extract_int(2)
        debug "altitude: #{altitude}"

        angle = extract_int(2)
        debug "angle: #{angle}"

        satelites = extract_int(1)
        debug "satelites: #{satelites}"

        speed = extract_int(2).to_s
        debug "speed: #{speed}"

        # I/O Elements
        event_id = extract_int(1)
        debug "event_id: #{event_id}"

        element_count = extract_int(1)
        debug "element_count: #{element_count}"

        element_count_1b = extract_int(1)
        debug "element_count_1b: #{element_count_1b}"

        take(element_count_1b * 2)

        element_count_2b = extract_int(1)
        debug "element_count_2b: #{element_count_2b}"
        take(element_count_2b * 3)

        element_count_4b = extract_int(1)
        debug "element_count_4b: #{element_count_4b}"
        take(element_count_4b * 5)

        element_count_8b = extract_int(1)
        debug "element_count_8b: #{element_count_8b}"
        take(element_count_8b * 9)

        result.push({
          "date"  => date,
          "lat"   => lat,
          "lng"   => lng,
          "speed" => speed,
        })
      end

      result
    end

    private def extract_int(len)
      take(len).map { |h| h.to_s(16).rjust(2, '0') }.join.to_i64(16, prefix: false)
    end

    private def take(len)
      @data.shift(len)
    end

    private def debug(str)
      if @debug
        puts str
      end
    end
  end
end
