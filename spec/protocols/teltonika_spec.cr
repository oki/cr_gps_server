require "../spec_helper"

describe "Protocols::Teltonika" do
  describe "IMEI package" do
    imei_bytes = StringUtils.hex_string_to_bin2("00 0f 33 35 32 30 39 33 30 38 34 32 36 38 30 34 33")

    proto = Protocols::Teltonika.new(imei_bytes)

    it "returns command name" do
      proto.command_name.should eq(:login)
    end

    it "returns device_id" do
      proto.device_id.should eq("352093084268043")
    end

    it "returns response" do
      proto.response.should eq(Bytes[1])
    end

    it "has correct package size" do
      proto.correct_package_size?.should be_truthy
    end
  end

  describe "AVL data package 2" do
    avl_bytes = StringUtils.hex_string_to_bin2("00 00 00 00 00 00 03 40 08 0e 00 00 01 64 fa 97 ae 90 00 0b df de 40 1d de 8f 66 00 00 00 00 00 00 00 f0 08 05 ef 00 f0 01 50 00 c8 02 45 03 03 42 00 00 43 0f 05 44 00 00 00 00 00 00 01 64 fa 73 88 a8 00 0b df de 40 1d de 8f 66 00 e3 00 53 06 00 00 f0 0c 06 ef 00 f0 00 50 01 15 00 c8 00 45 01 06 b5 00 1e b6 00 1d 42 00 00 18 00 00 43 0f 54 44 00 00 00 00 00 00 01 64 fa 72 7f 08 00 0b df d3 3f 1d de 8d 30 00 00 00 00 00 00 00 f0 0c 06 ef 00 f0 01 50 00 15 00 c8 00 45 01 06 b5 00 12 b6 00 10 42 00 00 18 00 00 43 0f 57 44 00 00 00 00 00 00 01 64 fa 6d 66 58 00 0b df d3 3f 1d de 8d 30 00 fa 01 0c 05 00 00 f0 0c 06 ef 00 f0 00 50 01 15 04 c8 00 45 01 06 b5 00 11 b6 00 0e 42 00 00 18 00 00 43 0f 83 44 00 00 00 00 00 00 01 64 fa 6c 4d 18 00 0b df d8 00 1d de 8f 98 00 f8 00 00 07 00 00 f0 0c 06 ef 00 f0 01 50 00 15 00 c8 00 45 01 06 b5 00 0f b6 00 0c 42 00 00 18 00 00 43 0f 8b 44 00 00 00 00 00 00 01 64 fa 6c 29 f0 00 0b df d8 00 1d de 8f 98 00 f8 00 00 07 00 00 f0 0c 06 ef 00 f0 00 50 01 15 00 c8 00 45 01 06 b5 00 0e b6 00 0b 42 00 00 18 00 00 43 0f 8b 44 00 00 00 00 00 00 01 64 fa 6b 33 d8 00 0b df d5 65 1d de 8f 02 00 f6 00 f1 07 00 08 00 0c 06 ef 00 f0 01 50 01 15 00 c8 00 45 01 06 b5 00 0f b6 00 0c 42 00 00 18 00 08 43 0f 92 44 00 00 00 00 00 00 01 64 fa 6b 2c 08 00 0b df d7 9b 1d de 8f ec 00 f1 00 fd 08 00 09 00 0c 06 ef 00 f0 01 50 01 15 00 c8 00 45 01 06 b5 00 0e b6 00 0b 42 00 00 18 00 09 43 0f 94 44 00 00 00 00 00 00 01 64 fa 6a e5 b8 00 0b df dd 24 1d de 92 ea 00 f8 00 24 09 00 00 00 0c 06 ef 00 f0 01 50 01 15 04 c8 00 45 01 06 b5 00 0d b6 00 0a 42 00 00 18 00 00 43 0f 91 44 00 00 00 00 00 00 01 64 fa 6a d6 18 00 0b df dc 6d 1d de 92 22 00 f9 00 2a 09 00 0b 00 0c 06 ef 00 f0 01 50 01 15 03 c8 00 45 01 06 b5 00 17 b6 00 0c 42 00 00 18 00 0b 43 0f 96 44 00 00 00 00 00 00 01 64 fa 6a c2 90 00 0b df d6 f5 1d de 8f b9 00 f2 00 36 06 00 07 00 0c 06 ef 00 f0 01 50 01 15 03 c8 00 45 01 06 b5 00 11 b6 00 0e 42 00 00 18 00 07 43 0f 92 44 00 00 00 00 00 00 01 64 fa 6a af 08 00 0b df dc 09 1d de 91 df 00 e2 00 dd 05 00 06 00 0c 06 ef 00 f0 01 50 01 15 03 c8 00 45 01 06 b5 00 2d b6 00 2c 42 00 00 18 00 06 43 0f 99 44 00 00 00 00 00 00 01 64 fa 6a 84 10 00 0b df e6 73 1d de 9a 99 00 f0 00 29 05 00 08 00 0c 06 ef 00 f0 01 50 01 15 03 c8 00 45 01 06 b5 00 35 b6 00 34 42 00 00 18 00 08 43 0f 94 44 00 00 00 00 00 00 01 64 fa 6a 80 28 00 0b df e5 26 1d de 99 6d 00 ee 00 37 07 00 12 00 0c 06 ef 00 f0 01 50 01 15 03 c8 00 45 01 06 b5 00 0f b6 00 0c 42 00 00 18 00 12 43 0f 93 44 00 00 00 00 0e 00 00 a0 10")

    proto = Protocols::Teltonika.new(avl_bytes)

    it "returns command name" do
      proto.command_name.should eq(:avl_data)
    end

    # 00 00 01 6B
    it "returns avl_data_length" do
      proto.avl_data_length.should eq(832)
    end

    it "has correct package size" do
      proto.correct_package_size?.should be_truthy
    end

    # 08
    it "returns codec ID" do
      proto.codec_id.should eq("08")
    end

    # 06
    it "returns avl_data_count" do
      proto.avl_data_count.should eq(14)
    end

    it "returns response" do
      proto.response.should eq(Bytes[0, 0, 0, 14])
    end

    it "returns gps_data" do
      # proto.gps_data.should eq(avl_bytes[9..-5])

      proto.gps_data[0].should eq(
        {
          "date"  => "2018-08-02 14:23:22 +02:00",
          "lat"   => "50.112497",
          "lng"   => "19.922080",
          "speed" => "0",
        }
      )

      proto.gps_data[-1].should eq(
        {
          "date"  => "2018-08-02 13:34:01 +02:00",
          "lat"   => "50.112753",
          "lng"   => "19.922257",
          "speed" => "18",
        }
      )
    end
  end

  describe "AVL data package" do
    avl_bytes = StringUtils.hex_string_to_bin2("00 00 00 00 00 00 01 6b 08 06 00 00 01 64 f7 08 ee 38 00 0b e6 50 a4 1d dc e0 69 00 e9 01 62 06 00 00 f0 0c 06 ef 00 f0 00 50 01 15 04 c8 00 45 01 06 b5 00 20 b6 00 1f 42 2d 48 18 00 00 43 0e 93 44 00 74 00 00 00 00 01 64 f7 08 5d b0 00 0b e6 4c 9a 1d dc c8 84 01 09 01 29 04 00 06 00 0c 06 ef 00 f0 01 50 01 15 03 c8 00 45 01 06 b5 00 49 b6 00 49 42 2d 53 18 00 06 43 0e 81 44 00 74 00 00 00 00 01 64 f7 07 fc 08 00 0b e6 6f 6f 1d dc d9 f7 01 14 01 35 04 00 04 00 0c 06 ef 00 f0 01 50 01 15 03 c8 00 45 01 06 b5 00 46 b6 00 45 42 2d 61 18 00 04 43 0e 65 44 00 74 00 00 00 00 01 64 f7 07 b1 d0 00 0b e6 44 66 1d dc c3 d4 00 00 00 00 00 00 00 f0 0c 06 ef 00 f0 01 50 00 15 03 c8 00 45 02 06 b5 00 64 b6 00 63 42 00 00 18 00 00 43 0e 02 44 00 00 00 00 00 00 01 64 f7 03 73 e0 00 0b e6 44 66 1d dc c3 d4 00 00 00 00 00 00 00 f0 0c 06 ef 00 f0 00 50 01 15 03 c8 00 45 02 06 b5 00 5a b6 00 59 42 00 00 18 00 00 43 0e 19 44 00 00 00 00 00 00 01 64 f7 02 6a 40 00 0b e6 48 b2 1d dc d5 15 00 00 00 00 00 00 00 f0 0c 06 ef 00 f0 01 50 00 15 00 c8 00 45 00 06 b5 00 00 b6 00 00 42 00 00 18 00 00 43 0e 42 44 00 00 00 00 06 00 00 01 9d")

    proto = Protocols::Teltonika.new(avl_bytes)

    it "returns command name" do
      proto.command_name.should eq(:avl_data)
    end

    # 00 00 01 6B
    it "returns avl_data_length" do
      proto.avl_data_length.should eq(363)
    end

    it "has correct package size" do
      proto.correct_package_size?.should be_truthy
    end

    # 08
    it "returns codec ID" do
      proto.codec_id.should eq("08")
    end

    # 06
    it "returns avl_data_count" do
      proto.avl_data_count.should eq(6)
    end

    it "returns response" do
      proto.response.should eq(Bytes[0, 0, 0, 6])
    end

    it "returns gps_data" do
      proto.gps_data.should eq([
        {
          "date"  => "2018-08-01 21:48:35 +02:00",
          "lat"   => "50.101463",
          "lng"   => "19.964330",
          "speed" => "0",
        },
        {
          "date"  => "2018-08-01 21:47:58 +02:00",
          "lat"   => "50.100852",
          "lng"   => "19.964227",
          "speed" => "6",
        },
        {
          "date"  => "2018-08-01 21:47:33 +02:00",
          "lat"   => "50.101298",
          "lng"   => "19.965118",
          "speed" => "4",
        },
        {
          "date"  => "2018-08-01 21:47:14 +02:00",
          "lat"   => "50.100732",
          "lng"   => "19.964017",
          "speed" => "0",
        },
        {
          "date"  => "2018-08-01 21:42:36 +02:00",
          "lat"   => "50.100732",
          "lng"   => "19.964017",
          "speed" => "0",
        },
        {
          "date"  => "2018-08-01 21:41:28 +02:00",
          "lat"   => "50.101173",
          "lng"   => "19.964127",
          "speed" => "0",
        },
      ])
    end
  end

  describe "AVL data incomplete package" do
    avl_bytes = StringUtils.hex_string_to_bin2("00 00 00 00 00 00 01 24 08 05 00 00 01 64 f9 70 f9 40 00 0b df d6 a2 1d de 90 c4 00 00 00 00 00 00 00 f0 0c 06 ef 00 f0 01 50 00 15 04 c8 00 45 02 06 b5 00 0a")

    avl_data_length = 292

    proto = Protocols::Teltonika.new(avl_bytes)

    it "returns command name" do
      proto.command_name.should eq(:avl_data)
    end

    it "returns avl_data_length" do
      proto.avl_data_length.should eq(avl_data_length)
    end

    it "has not correct package size" do
      proto.correct_package_size?.should be_false
    end

    it "returns rest size to read" do
      expected_size = avl_data_length + 4 + 4 + 4
      current_size = avl_bytes.size
      proto.rest_size_to_read.should eq(expected_size - current_size)
    end

    it "returns response" do
      proto.response.should eq(Bytes[0, 0, 0, 5])
    end
  end

  describe "AVL data package 2" do
    # avl_bytes = StringUtils.hex_string_to_bin2("00 00 00 00 00 00 00 44 08 01 00 00 01 65 18 e6 4d 98 00 0b df d5 12 1d de 91 28 00 e5 01 42 09 00 00 f0 0d 06 ef 00 f0 00 50 01 15 03 c8 00 45 01 06 b5 00 0d b6 00 0a 42 2c ba 18 00 00 43 0c f9 44 00 00 01 10 00 04 de 18 00 01 00 00 42 bd")
    # avl_bytes = StringUtils.hex_string_to_bin2("00 00 00 00 00 00 01 0d 08 04 00 00 01 65 18 f5 8b f0 00 0b df d5 12 1d de 91 28 00 e5 01 42 13 00 00 f7 0e 07 ef 00 f0 01 50 01 15 03 c8 00 45 01 f7 01 06 b5 00 09 b6 00 06 42 2c ba 18 00 00 43 0c f0 44 00 00 01 10 00 04 de 18 00 00 00 01 65 18 f5 26 60 00 0b df d5 12 1d de 91 28 00 e5 01 42 13 00 00 f6 0e 07 ef 00 f0 01 50 00 15 03 c8 00 45 01 f6 01 06 b5 00 09 b6 00 06 42 2c ba 18 00 00 43 0c f0 44 00 00 01 10 00 04 de 18 00 00 00 01 65 18 f5 22 82 00 0b df d5 12 1d de 91 28 00 e5 00 00 09 00 00 f7 0e 07 ef 00 f0 01 50 00 15 03 c8 00 45 01 f7 01 06 b5 00 09 b6 00 06 42 2c ba 18 00 00 43 0c f0 44 00 00 01 10 00 04 de 18 00 00 00 01 65 18 f5 22 78 00 0b df d5 12 1d de 91 28 00 e5 00 00 09 00 00 f0 0d 06 ef 00 f0 01 50 00 15 03 c8 00 45 01 06 b5 00 09 b6 00 06 42 2c ba 18 00 00 43 0c f0 44 00 00 01 10 00 04 de 18 00 04 00 00 a5 c7")
    avl_bytes = StringUtils.hex_string_to_bin2("00 00 00 00 00 00 00 f7 08 04 00 00 01 65 19 03 95 b0 01 0b df d7 7a 1d de 90 92 00 00 00 00 00 00 00 fc 0e 07 ef 00 f0 01 50 01 15 00 c8 00 45 02 fc 01 06 b5 00 0c b6 00 09 42 0a 2c 18 00 00 43 0c d1 44 00 00 01 10 00 04 de 18 00 00 00 01 65 19 03 8d ea 00 0b df d7 7a 1d de 90 92 00 00 00 00 00 00 00 f7 0e 07 ef 00 f0 01 50 01 15 00 c8 00 45 02 f7 01 06 b5 00 0c b6 00 09 42 2a 8b 18 00 00 43 0d 05 44 00 00 01 10 00 04 de 18 00 00 00 01 65 19 03 8d e0 00 0b df d7 7a 1d de 90 92 00 00 00 00 00 00 00 f6 0a 06 ef 00 f0 01 50 00 c8 02 45 03 f6 01 03 42 2c ba 43 0d 0c 44 00 00 01 10 00 04 de 18 00 00 00 01 65 19 03 89 f8 00 0b df d7 7a 1d de 90 92 00 00 00 00 00 00 00 f0 09 05 ef 00 f0 01 50 00 c8 02 45 03 03 42 2c ba 43 0d 0c 44 00 00 01 10 00 04 de 18 00 04 00 00 7f f9")

    proto = Protocols::Teltonika.new(avl_bytes)

    it "returns command name" do
      proto.command_name.should eq(:avl_data)
    end

    it "returns avl_data_length" do
      proto.avl_data_length.should eq(247)
    end

    it "has correct package size" do
      proto.correct_package_size?.should be_truthy
    end

    # 08
    it "returns codec ID" do
      proto.codec_id.should eq("08")
    end

    # 06
    it "returns avl_data_count" do
      proto.avl_data_count.should eq(4)
    end

    it "returns gps_data" do
      proto.gps_data.should eq([
        {
          "date"  => "2018-08-08 12:09:50 +02:00",
          "lat"   => "50.112527",
          "lng"   => "19.921907",
          "speed" => "0",
        },
        {
          "date"  => "2018-08-08 12:09:48 +02:00",
          "lat"   => "50.112527",
          "lng"   => "19.921907",
          "speed" => "0",
        },
        {
          "date"  => "2018-08-08 12:09:48 +02:00",
          "lat"   => "50.112527",
          "lng"   => "19.921907",
          "speed" => "0",
        },
        {
          "date"  => "2018-08-08 12:09:47 +02:00",
          "lat"   => "50.112527",
          "lng"   => "19.921907",
          "speed" => "0",
        },
      ])
    end

    it "returns io_events" do
      proto.io_events.should eq([
        {
          "date"                => "2018-08-08 12:09:50 +02:00",
          "event_name"          => "unplug_event",
          "ignition"            => "0",
          "movement"            => "1",
          "data_mode"           => "1",
          "gsm_signal_strength" => "0",
          "sleep_mode"          => "0",
          "gnss_status"         => "2",
          "unplug_event"        => "1",
          "pdop"                => "12",
          "hdop"                => "9",
          "ext_voltage"         => "2604",
          "speed"               => "0",
          "battery_voltage"     => "3281",
          "battery_current"     => "0",
          "total_odometer"      => "319000",
        },
        {
          "date"                => "2018-08-08 12:09:48 +02:00",
          "event_name"          => "crash_detection",
          "ignition"            => "0",
          "movement"            => "1",
          "data_mode"           => "1",
          "gsm_signal_strength" => "0",
          "sleep_mode"          => "0",
          "gnss_status"         => "2",
          "crash_detection"     => "1",
          "pdop"                => "12",
          "hdop"                => "9",
          "ext_voltage"         => "10891",
          "speed"               => "0",
          "battery_voltage"     => "3333",
          "battery_current"     => "0",
          "total_odometer"      => "319000",
        },
        {
          "date"                   => "2018-08-08 12:09:48 +02:00",
          "event_name"             => "towing_detection_event",
          "ignition"               => "0",
          "movement"               => "1",
          "data_mode"              => "0",
          "sleep_mode"             => "2",
          "gnss_status"            => "3",
          "towing_detection_event" => "1",
          "ext_voltage"            => "11450",
          "battery_voltage"        => "3340",
          "battery_current"        => "0",
          "total_odometer"         => "319000",
        },
        {
          "date"            => "2018-08-08 12:09:47 +02:00",
          "event_name"      => "movement",
          "ignition"        => "0",
          "movement"        => "1",
          "data_mode"       => "0",
          "sleep_mode"      => "2",
          "gnss_status"     => "3",
          "ext_voltage"     => "11450",
          "battery_voltage" => "3340",
          "battery_current" => "0",
          "total_odometer"  => "319000",
        },
      ])
    end
  end

  describe "AVL negativ gps package" do
    avl_bytes = StringUtils.hex_string_to_bin2("00 00 00 00 00 00 00 59 08 01 00 00 01 65 7a 6c 9c 98 00 ff b5 b0 d3 17 2e 00 d1 00 d9 00 00 11 00 00 00 10 06 ef 01 f0 00 50 04 15 04 c8 00 45 01 07 b5 00 0b b6 00 07 42 62 29 18 00 00 43 0f 9c 44 00 00 0f 00 00 01 10 00 36 1d 04 02 0b 00 00 00 02 15 58 93 7a 0e 00 00 00 00 1e 14 84 62 01 00 00 a8 fd")

    proto = Protocols::Teltonika.new(avl_bytes)

    it "returns command name" do
      proto.command_name.should eq(:avl_data)
    end

    it "returns avl_data_length" do
      proto.avl_data_length.should eq(89)
    end

    it "has correct package size" do
      proto.correct_package_size?.should be_truthy
    end

    it "returns avl_data_count" do
      proto.avl_data_count.should eq(1)
    end

    it "returns gps_data" do
      proto.gps_data.should eq([
        {
          "date"  => "2018-08-27 10:07:43 +02:00",
          "lat"   => "38.889083",
          "lng"   => "-0.486993",
          "speed" => "0",
        },
      ])
    end

    it "returns io_events" do
      proto.io_events.should eq([
        {
          "date"                => "2018-08-27 10:07:43 +02:00",
          "event_name"          => "unknown: 0",
          "ignition"            => "1",
          "movement"            => "0",
          "data_mode"           => "4",
          "gsm_signal_strength" => "4",
          "sleep_mode"          => "0",
          "gnss_status"         => "1",
          "pdop"                => "11",
          "hdop"                => "7",
          "ext_voltage"         => "25129",
          "speed"               => "0",
          "battery_voltage"     => "3996",
          "battery_current"     => "0",
          "eco_score"           => "0",
          "total_odometer"      => "3546372",
          "sim_iccid1_number"   => "8948061050",
          "sim_iccid2_number"   => "504661090",
          "sim_iccid"           => "89480610500504661090",
        },
      ])
    end
  end

  describe "AVL negativ gps package 2" do
    # fe d7 34 5e
    avl_bytes = StringUtils.hex_string_to_bin2("00 00 00 00 00 00 00 59 08 01 00 00 01 65 7A 6C 9C 98 00 FE D7 34 5E 17 2E 00 D1 00 D9 00 00 11 00 00 00 10 06 EF 01 F0 00 50 04 15 04 C8 00 45 01 07 B5 00 0B B6 00 07 42 62 29 18 00 00 43 0F 9C 44 00 00 0F 00 00 01 10 00 36 1D 04 02 0B 00 00 00 02 15 58 93 7A 0E 00 00 00 00 1E 14 84 62 01 00 00 A8 FD")

    proto = Protocols::Teltonika.new(avl_bytes)

    it "has correct package size" do
      proto.correct_package_size?.should be_truthy
    end

    it "returns gps_data" do
      proto.gps_data.should eq([
        {
          "date"  => "2018-08-27 10:07:43 +02:00",
          "lat"   => "38.889083",
          "lng"   => "-1.945079",
          "speed" => "0",
        },
      ])
    end
  end

  describe "AVL data package 4" do
    avl_bytes = StringUtils.hex_string_to_bin2("00 00 00 00 00 00 00 59 08 01 00 00 01 65 33 1b 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 10 06 ef 00 f0 00 50 01 15 03 c8 00 45 02 07 b5 00 00 b6 00 00 42 00 00 18 00 00 43 0e d3 44 00 00 0f 00 00 01 10 00 00 00 00 02 0b 00 00 00 02 15 58 93 7a 0e 00 00 00 00 1e 14 99 6f 01 00 00 74 7b")

    proto = Protocols::Teltonika.new(avl_bytes)

    it "returns io_events" do
      proto.io_events.should eq([
        {
          "date"                => "2018-08-13 13:45:36 +02:00",
          "event_name"          => "movement",
          "ignition"            => "0",
          "movement"            => "0",
          "data_mode"           => "1",
          "gsm_signal_strength" => "3",
          "sleep_mode"          => "0",
          "gnss_status"         => "2",
          "pdop"                => "0",
          "hdop"                => "0",
          "ext_voltage"         => "0",
          "speed"               => "0",
          "battery_voltage"     => "3795",
          "battery_current"     => "0",
          "eco_score"           => "0",
          "total_odometer"      => "0",
          "sim_iccid1_number"   => "8948061050",
          "sim_iccid2_number"   => "504666479",
          "sim_iccid"           => "89480610500504666479",
        },
      ])
    end
  end
end
