module Protocols
  class Teltonika
    @data : Array(UInt8)

    def initialize(@data)
      @data = data
    end

    def command_name
      if imei_package?
        :login
      elsif avl_data_package?
        :avl_data
      else
        :unknown
      end
    end

    def imei_len
      @data[1]
    end

    def device_id
      imei = @data[2..imei_len + 2]
      imei.map { |b| b.to_s(10).to_i.chr }.join
    end

    def response
      # io = IO::Memory.new

      data = case command_name
             when :login
               slice = Bytes.new(1)
               slice[0] = 0x01
               slice
             when :avl_data
               slice = Bytes.new(4)
               [0x00, 0x00, 0x00, avl_data_count_raw]
               slice[0] = 0x00
               slice[1] = 0x00
               slice[2] = 0x00
               slice[3] = avl_data_count_raw
               slice
             else
               slice = Bytes.new(1)
               slice[0] = 0x00
               slice
             end
      data
    end

    def imei_package?
      @data[0..1] == [0_u8, 15_u8]
    end

    def avl_data_package?
      @data[0..3] == [0_u8, 0_u8, 0_u8, 0_u8]
    end

    def avl_data_length
      @data[4..(4 + 3)].map { |h| h.to_s(16).rjust(2, '0') }.join.to_i64(16, prefix: false)
    end

    def codec_id
      "%02d" % @data[8].to_s(16).to_i
    end

    def avl_data_count_raw
      @data[9]
    end

    def avl_data_count
      avl_data_count_raw.to_s(16).rjust(2, '0').to_i64(16, prefix: false)
    end

    def avl_data
      offset = 9
      @_avl_data ||= TeltonikaAvlData.new(@data[offset..-5])
    end

    def gps_data
      offset = 9
      avl_data.gps_data
    end

    def io_events
      offset = 9
      avl_data.io_events
    end

    def correct_package_size?
      @data.size == expected_package_size
    end

    def rest_size_to_read
      expected_package_size - @data.size
    end

    private def expected_package_size
      case command_name
      when :login
        imei_len + 2
      when :avl_data
        preable_size = 4
        size_len = 4
        crc_len = 4
        avl_data_length + preable_size + size_len + crc_len
      else
        0
      end
    end

    private def as_string(bytes)
      bytes.map(&.chr).join
    end
  end
end
