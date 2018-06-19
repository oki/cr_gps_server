require "../spec_helper"

describe "Protocols::Tk103" do
  describe "3.2.2 Login message BP05" do
    login_bytes = StringUtils.hex_string_to_bin("28 30 38 37 30 37 34 39 37 30 31 36 35 42 50 30 35 33 35 32 38 38 37 30 37 34 39 37 30 31 36 35 31 38 30 35 32 32 41 35 30 30 38 2e 38 39 30 33 4e 30 31 39 31 38 2e 31 38 33 38 45 31 35 33 2e 32 31 30 34 36 33 31 32 37 36 2e 34 36 31 31 30 30 30 30 30 30 4c 30 30 30 34 35 30 41 42 29")

    proto = Protocols::Tk103.new(login_bytes)

    it "returns running_time" do
      proto.running_time.should eq("087074970165")
    end

    it "returns command" do
      proto.command.should eq("BP05")
    end

    it "returns command name" do
      proto.command_name.should eq(:login)
    end

    it "returns device_id" do
      proto.device_id.should eq("352887074970165")
    end

    it "returns body" do
      proto.body.should eq("180522A5008.8903N01918.1838E153.2104631276.4611000000L000450")
    end

    it "returns response" do
      proto.response.should eq("(087074970165AP05)")
    end

    it "returns gps_data" do
      proto.gps_data.should eq({
        date: "2018-05-22 12:46:31 +02:00",
        lat: "50.148172",
        lng: "19.303063",
        speed: 153.21
      })
    end
  end
end
