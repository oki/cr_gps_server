require "./spec_helper"

describe StringUtils do
  describe "#bin_to_hex" do
    it "converts binary to hex string" do
      binary = [120_u8,
                120_u8,
                13_u8,
                1_u8,
                3_u8,
                82_u8,
                136_u8,
                112_u8,
                120_u8,
                0_u8,
                55_u8,
                129_u8,
                0_u8,
                12_u8,
                221_u8,
                32_u8,
                13_u8,
                10_u8,
      ]

      StringUtils.bin_to_hex(binary).join(" ").should eq("78 78 0d 01 03 52 88 70 78 00 37 81 00 0c dd 20 0d 0a")
    end
  end

  describe "#hex_string_to_bin" do
    it "converts hex string to binary array" do
      string = "0d 01 03 52 88 70 78 00 37 81 00 0c"
      binary = StringUtils.hex_string_to_bin(string)
      binary.should eq([13_u8, 1_u8, 3_u8, 82_u8, 136_u8, 112_u8, 120_u8, 0_u8, 55_u8, 129_u8, 0_u8, 12_u8])
    end
  end
end
