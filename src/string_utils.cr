class StringUtils
  def self.bin_to_hex(s)
    s.map { |b| b.to_s(16).rjust(2, '0') }
  end

  def self.hex_string_to_bin(s)
    s.split.map(&.to_u8(16))
  end
end
