require "socket"
require "../src/string_utils"

host = "127.0.0.1"
port = 5022

login = StringUtils.hex_string_to_bin("78 78 0d 01 03 52 88 70 78 00 37 81 00 02 34 5e 0d 0a").map(&.chr).join

pp StringUtils.bin_to_hex(login.bytes).join(" ")

sock = Socket.tcp(Socket::Family::INET)
sock.connect host, port

puts "Sending login package"
sock.send login
puts "OK"

sleep 10

loop do
  puts "Sending handshake package"

  # sleep 1
  puts "Sending gps package"
  location = StringUtils.hex_string_to_bin("78 78 1f 12 12 05 16 08 07 0a c7 05 60 61 ce 02 23 2b 97 FF 14 00 01 04 03 ce 41 00 14 bf 00 c4 0f 9d 0d 0a").map(&.chr).join
  sock.send location
  puts "Ok"
  sleep 10
end

# sock.close
