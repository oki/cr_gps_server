require "socket"
require "../src/string_utils"

host = "127.0.0.1"
port = 5023

hex_login = "28 30 38 37 30 37 34 39 37 30 31 36 35 42 50 30 35 29"
hex_handshake = "28 30 38 37 30 37 34 39 37 30 31 36 35 42 50 30 30 33 35 32 38 38 37 30 37 34 39 37 30 31 36 35 48 53 4f 30 31 38 39 29"

login = StringUtils.hex_string_to_bin(hex_login).map(&.chr).join
handshake = StringUtils.hex_string_to_bin(hex_handshake).map(&.chr).join

sock = Socket.tcp(Socket::Family::INET)
sock.connect host, port

puts "Sending login package"
sock.send login
puts "OK"

loop do
  puts "Sending handshake package"

  # sleep 1
  puts "Sending gps package"
  sock.send "(087074970165BR00180522A5213.6890N01814.9675E000.3152200000.0011000000L000450AB)"
  puts "Ok"
  sleep 10
  sock.send handshake
end
# sock.close
