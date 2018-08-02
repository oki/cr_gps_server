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

    it "returns avl_data" do
      # proto.avl_data.should eq(avl_bytes[9..-5])

      proto.avl_data.should eq([
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

    it "returns response" do
      proto.response.should eq(Bytes[0, 0, 0, 6])
    end

    it "returns response" do
      proto.response.should eq(Bytes[0, 0, 0, 6])
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
end
