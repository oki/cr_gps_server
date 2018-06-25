require "./spec_helper"

describe CrcItu do
  hex_to_int = ->(str : String) {
    str.split.map(&.to_i32(16))
  }

  int_to_hex = ->(n : Int32) {
    n.to_s(16).rjust(4, '0')
  }

  it "calculates crc: 05dd" do
    str = "0d 01 03 52 88 70 78 00 37 81 00 32"
    result = CrcItu.crc(hex_to_int.call(str))
    int_to_hex.call(result).should eq("05dd")
  end

  it "calculates crc: 40e1" do
    str = "0d 01 03 52 88 70 78 00 37 81 00 05"
    result = CrcItu.crc(hex_to_int.call(str))
    int_to_hex.call(result).should eq("40e1")
  end

  it "calculates crc: 9b04" do
    str = "0d 01 03 52 88 70 78 00 37 81 00 08"
    result = CrcItu.crc(hex_to_int.call(str))
    int_to_hex.call(result).should eq("9b04")
  end

  it "calculates crc: b476" do
    str = "0d 01 03 52 88 70 78 00 37 81 00 c6"
    result = CrcItu.crc(hex_to_int.call(str))
    int_to_hex.call(result).should eq("b476")
  end

  it "calculates crc: d9dc (from doc)" do
    str = "05 01 00 01"
    result = CrcItu.crc(hex_to_int.call(str))
    int_to_hex.call(result).should eq("d9dc")
  end

  it "calculates crc: 0239" do
    str = "05 01 00 0c"
    result = CrcItu.crc(hex_to_int.call(str))
    int_to_hex.call(result).should eq("0239")
  end

  it "calculates crc: f970" do
    str = "05 13 00 11"
    result = CrcItu.crc(hex_to_int.call(str))
    int_to_hex.call(result).should eq("f970")
  end
end
