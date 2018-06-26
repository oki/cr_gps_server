require "../spec_helper"

describe "Protocols::Gt06" do
  describe "login package 00" do
    login_bytes = StringUtils.hex_string_to_bin2("78 78 0d 01 03 52 88 70 78 00 37 81 00 0c dd 20 0d 0a")

    proto = Protocols::Gt06.new(login_bytes)

    it "returns correct packet_length" do
      proto.packet_length.should eq(13)
    end

    it "returns correct protocol_number" do
      proto.protocol_number.should eq(:login)
    end

    it "returns correct content" do
      response = StringUtils.hex_string_to_bin2("03 52 88 70 78 00 37 81")
      proto.content.should eq(response)
    end

    it "returns correct content_for_checksum" do
      response = StringUtils.hex_string_to_bin2("0d 01 03 52 88 70 78 00 37 81 00 0c")
      proto.content_for_checksum.should eq(response)
    end

    it "returns check sum" do
      response = StringUtils.hex_string_to_bin2("dd 20")
      proto.checksum.should eq(response)
    end

    it "returns serial_number" do
      response = StringUtils.hex_string_to_bin2("00 0c")
      proto.serial_number.should eq(response)
    end

    it "has be valid package" do
      proto.valid?.should eq(true)
    end

    it "returns reponse" do
      package = StringUtils.hex_string_to_bin2("78 78 05 01 00 0c 02 39 0D 0A")
      proto.response.should eq(package)
    end

    it "returns device_id from data" do
      proto.data.should eq({"device_id" => "352887078003781"})
    end
  end

  describe "login package 01" do
    data = StringUtils.hex_string_to_bin2("78 78 0d 01 03 52 88 70 78 00 37 81 00 05 40 e1 0d 0a")
    proto = Protocols::Gt06.new(data)

    it "has be valid package" do
      proto.valid?.should eq(true)
    end

    it "returns reponse" do
      package = StringUtils.hex_string_to_bin2("78 78 05 01 00 05 9f f8 0D 0A")
      proto.response.should eq(package)
    end
  end

  describe "login package (real)" do
    data = StringUtils.hex_string_to_bin2("78 78 0d 01 03 52 88 70 78 00 37 81 00 02 34 5e 0d 0a")
    proto = Protocols::Gt06.new(data)

    it "has be valid package" do
      proto.valid?.should eq(true)
    end

    it "returns reponse" do
      package = StringUtils.hex_string_to_bin2("78 78 05 01 00 02 EB 47 0D 0A")
      proto.response.should eq(package)
    end

    it "returns device_id" do
      # 352c28870780037
      # 352887078003781
      proto.login_data.should eq({"device_id" => "352887078003781"})
    end
  end

  describe "login package (from doc)" do
    data = StringUtils.hex_string_to_bin2("78 78 0D 01 01 23 45 67 89 01 23 45 00 01 8C DD 0D 0A")
    proto = Protocols::Gt06.new(data)

    it "has be valid package" do
      proto.valid?.should eq(true)
    end

    it "returns reponse" do
      package = StringUtils.hex_string_to_bin2("78 78 05 01 00 01 D9 DC 0D 0A")
      proto.response.should eq(package)
    end

    it "returns login protocol type" do
      proto.protocol_number.should eq(:login)
    end

    it "returns device_id from data" do
      proto.data.should eq({"device_id" => "123456789012345"})
    end
  end

  describe "package (from doc)" do
    data = StringUtils.hex_string_to_bin2("78 78 05 13 00 11 F9 70 0D 0A")
    proto = Protocols::Gt06.new(data)

    it "has be valid package" do
      proto.valid?.should eq(true)
    end
  end

  describe "location package (doc)" do
    data = StringUtils.hex_string_to_bin2("78 78 1f 12 0A 03 17 0F 32 17 cc 02 7a c7 eb 0c 46 58 49 26 14 8f 01 cc 00 28 7d 00 1f b8 00 03 80 81 0d 0a")
    proto = Protocols::Gt06.new(data)

    it "returns location protocol type" do
      proto.protocol_number.should eq(:location)
    end

    it "returns data" do
      proto.data.should eq({
        "date"  => "2010-03-23 17:50:23 +02:00",
        "lat"   => "23.111668",
        "lng"   => "114.409285",
        "speed" => "38",
        # "gps_positioned" => true,
        # "gps_realtime"   => false,
      }
      )
    end
  end

  describe "alarm package" do
    data = StringUtils.hex_string_to_bin2("78 78 25 16 04 01 01 00 0b 37 c0 05 60 0f 81 02 24 5a a0 01 04 00 09 00 00 00 00 00 00 00 00 00 03 00 02 01 00 01 6b b8 0d 0a")

    proto = Protocols::Gt06.new(data)

    it "returns location protocol type" do
      proto.protocol_number.should eq(:alarm)
    end

    # it "returns data" do
    #   proto.data.should eq({
    #     "date"  => "2018-05-22 10:07:10 +02:00",
    #     "lat"   => "50.112541",
    #     "lng"   => "19.921862",
    #     "speed" => "255",
    #     # "gps_positioned" => true,
    #     # "gps_realtime"   => false,
    #   }
    #   )
    # end
  end
  describe "location package (real)" do
    data = StringUtils.hex_string_to_bin2("78 78 1f 12 12 05 16 08 07 0a c7 05 60 61 ce 02 23 2b 97 FF 14 00 01 04 03 ce 41 00 14 bf 00 c4 0f 9d 0d 0a")

    proto = Protocols::Gt06.new(data)

    it "returns location protocol type" do
      proto.protocol_number.should eq(:location)
    end

    it "returns data" do
      proto.data.should eq({
        "date"  => "2018-05-22 10:07:10 +02:00",
        "lat"   => "50.112541",
        "lng"   => "19.921862",
        "speed" => "255",
        # "gps_positioned" => true,
        # "gps_realtime"   => false,
      }
      )
    end
  end

  describe "status package" do
    data = StringUtils.hex_string_to_bin2("78 78 0a 13 44 05 04 00 00 00 61 67 17 0d 0a")
    proto = Protocols::Gt06.new(data)

    it "has be valid package" do
      proto.valid?.should eq(true)
    end

    it "returns status_information protocol type" do
      proto.protocol_number.should eq(:status_information)
    end

    # it "returns data" do
    #   proto.data.should eq({
    #     acc_high:                false,
    #     activated:               true,
    #     charge:                  true,
    #     gas_oil_and_electricity: false,
    #     gps_tracking:            false,
    #     gsm_level:               4,
    #     voltage_level:           5,
    #   })
    # end
  end
end
