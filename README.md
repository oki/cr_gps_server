# gps_server

TODO: Write a description here

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/gps_server/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [your-github-user](https://github.com/your-github-user) Michał Kurek - creator, maintainer


root@s2-api:/etc/packetbeat# ss -s
Total: 194 (kernel 213)
TCP:   214 (estab 102, closed 106, orphaned 0, synrecv 0, timewait 106/0), ports 0

Transport Total     IP        IPv6
*         213       -         -
RAW       0         0         0
UDP       0         0         0
TCP       108       107       1
INET      108       107       1
FRAG      0         0         0

root@s2-api:/etc/packetbeat# cat /proc/net/sockstat
sockets: used 195
TCP: inuse 108 orphan 0 tw 93 alloc 109 mem 39
UDP: inuse 0 mem 0
UDPLITE: inuse 0
RAW: inuse 0
FRAG: inuse 0 memory 0


Teltonika:

00 00 00 00 00 00 03 c3 08 10 00 00 01 64 f5 f9 bc
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 00 00 00 00 03 c3 08 10 00 00 01 64 f5 ac c9
try: 2
[Teltonika] [2018-08-01 15:48:49] received data: 38 00 0b df d4 18 1d de 8e e1 00 e8 00 f5 0b 00 00
try: 3
[Teltonika] [2018-08-01 15:48:49] received data: f0 0c 06 ef 00 f0 00 50 01 15 05 c8 00 45 01 06 b5
try: 4
[Teltonika] [2018-08-01 15:48:49] received data: 00 0b b6 00 08 42 2f 18 18 00 00 43 0f a2 44 00 00
try: 5
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 00 00 01 64 f5 ab c7 68 00 0b df d4 18 1d de
try: 6
[Teltonika] [2018-08-01 15:48:49] received data: 8e e1 00 e8 00 00 0f 00 00 f0 0c 06 ef 00 f0 01 50
try: 7
[Teltonika] [2018-08-01 15:48:49] received data: 00 15 05 c8 00 45 01 06 b5 00 0a
try: 8
[Teltonika] [2018-08-01 15:48:49] received data: b6 00 07 42 2f 1e 18 00 00 43 0f a5 44 00 00 00 00
try: 9
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 01 64 f5 a5 10 a8 00 0b df d4 18 1d de 8e e1
try: 10
[Teltonika] [2018-08-01 15:48:49] received data: 00 e8 00 f5 0f 00 00 f0 0c 06 ef 00 f0 00 50 01 15
try: 11
[Teltonika] [2018-08-01 15:48:49] received data: 04 c8 00 45 01 06 b5 00 09 b6 00 06 42 2f 1e 18 00
try: 12
[Teltonika] [2018-08-01 15:48:49] received data: 00 43 0f a5 44 00 00 00 00 00 00 01 64 f5 a4 12 c0
try: 13
[Teltonika] [2018-08-01 15:48:49] received data: 00 0b df d4 18 1d de 8e e1 00 e8 00 00 11 00 00 f0
try: 14
[Teltonika] [2018-08-01 15:48:49] received data: 0c 06 ef 00 f0 01 50 00 15 05 c8 00 45 01 06 b5 00
try: 15
try: 16
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 00 01 64 f5 a1 6e f8 00 0b df d4 18 1d de 8e
try: 17
[Teltonika] [2018-08-01 15:48:49] received data: e1 00 e8 00 f5 11 00 00 f0 0c 06 ef 00 f0 00 50 01
try: 18
[Teltonika] [2018-08-01 15:48:49] received data: 15 04 c8 00 45 01 06 b5 00 09 b6 00 06 42 2f 1e 18
try: 19
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 43 0f a5 44 00 00 00 00 00 00 01 64 f5 a0 51
try: 20
[Teltonika] [2018-08-01 15:48:49] received data: d0 00 0b df d4 18 1d de 8e e1 00 e8 00 00 0e 00 00
try: 21
[Teltonika] [2018-08-01 15:48:49] received data: f0 0c 06 ef 00 f0 01 50 00 15 04 c8 00 45 01 06 b5
try: 22
[Teltonika] [2018-08-01 15:48:49] received data: 00 0a
try: 23
[Teltonika] [2018-08-01 15:48:49] received data: b6 00 07 42 2f 20 18 00 00 43 0f a5 44 00 00 00 00
try: 24
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 01 64 f5 a0 4d e8 00 0b df d4 18 1d de 8e e1
try: 25
[Teltonika] [2018-08-01 15:48:49] received data: 00 e8 00 f5 0e 00 00 f0 0c 06 ef 00 f0 00 50 01 15
try: 26
[Teltonika] [2018-08-01 15:48:49] received data: 04 c8 00 45 01 06 b5 00 0a
try: 27
[Teltonika] [2018-08-01 15:48:49] received data: b6 00 07 42 2f 20 18 00 00 43 0f a5 44 00 00 00 00
try: 28
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 01 64 f5 9f 44 48 00 0b df d4 18 1d de 8e e1
try: 29
[Teltonika] [2018-08-01 15:48:49] received data: 00 e8 00 00 0f 00 00 f0 0c 06 ef 00 f0 01 50 00 15
try: 30
[Teltonika] [2018-08-01 15:48:49] received data: 03 c8 00 45 01 06 b5 00 09 b6 00 07 42 2f 21 18 00
try: 31
[Teltonika] [2018-08-01 15:48:49] received data: 00 43 0f a5 44 00 00 00 00 00 00 01 64 f5 9e fd f8
try: 32
[Teltonika] [2018-08-01 15:48:49] received data: 00 0b df d4 18 1d de 8e e1 00 e8 00 f5 0f 00 00 f0
try: 33
[Teltonika] [2018-08-01 15:48:49] received data: 0c 06 ef 00 f0 00 50 01 15 04 c8 00 45 01 06 b5 00
try: 34
[Teltonika] [2018-08-01 15:48:49] received data: 09 b6 00 06 42 2f 29 18 00 00 43 0f a5 44 00 00 00
try: 35
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 00 01 64 f5 9d f8 40 00 0b df d4 18 1d de 8e
try: 36
[Teltonika] [2018-08-01 15:48:49] received data: e1 00 e8 00 00 0e 00 00 f0 0c 06 ef 00 f0 01 50 00
try: 37
[Teltonika] [2018-08-01 15:48:49] received data: 15 03 c8 00 45 01 06 b5 00 0a
try: 38
[Teltonika] [2018-08-01 15:48:49] received data: b6 00 07 42 2f 2d 18 00 00 43 0f a5 44 00 00 00 00
try: 39
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 01 64 f5 9d f0 70 00 0b df d4 18 1d de 8e e1
try: 40
[Teltonika] [2018-08-01 15:48:49] received data: 00 e8 00 f5 0e 00 00 f0 0c 06 ef 00 f0 00 50 01 15
try: 41
[Teltonika] [2018-08-01 15:48:49] received data: 03 c8 00 45 01 06 b5 00 0a
try: 42
[Teltonika] [2018-08-01 15:48:49] received data: b6 00 07 42 2f 2f 18 00 00 43 0f a5 44 00 00 00 00
try: 43
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 01 64 f5 9c 7d 58 00 0b df d4 18 1d de 8e e1
try: 44
[Teltonika] [2018-08-01 15:48:49] received data: 00 e8 00 00 0e 00 00 f0 0c 06 ef 00 f0 01 50 00 15
try: 45
[Teltonika] [2018-08-01 15:48:49] received data: 03 c8 00 45 01 06 b5 00 0a
try: 46
[Teltonika] [2018-08-01 15:48:49] received data: b6 00 07 42 2f 38 18 00 00 43 0f a2 44 00 00 00 00
try: 47
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 01 64 f5 9c 69 d0 00 0b df d4 18 1d de 8e e1
try: 48
[Teltonika] [2018-08-01 15:48:49] received data: 00 e8 00 f5 0e 00 00 f0 0c 06 ef 00 f0 00 50 01 15
try: 49
[Teltonika] [2018-08-01 15:48:49] received data: 03 c8 00 45 01 06 b5 00 0a
try: 50
[Teltonika] [2018-08-01 15:48:49] received data: b6 00 07 42 2f 39 18 00 00 43 0f a2 44 00 00 00 00
try: 51
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 01 64 f5 9a a4 b0 00 0b df d8 c8 1d de 91 cf
try: 52
[Teltonika] [2018-08-01 15:48:49] received data: 00 e6 00 00 0b 00 00 f0 0c 06 ef 00 f0 01 50 00 15
try: 53
[Teltonika] [2018-08-01 15:48:49] received data: 04 c8 00 45 01 06 b5 00 0b b6 00 08 42 2f 41 18 00
try: 54
[Teltonika] [2018-08-01 15:48:49] received data: 00 43 0f a0 44 00 00 00 00 00 00 01 64 f5 9a 5a 78
try: 55
[Teltonika] [2018-08-01 15:48:49] received data: 00 0b df d8 c8 1d de 91 cf 00 e6 00 9d 0b 00 00 f0
try: 56
[Teltonika] [2018-08-01 15:48:49] received data: 0c 06 ef 00 f0 00 50 01 15 04 c8 00 45 01 06 b5 00
try: 57
[Teltonika] [2018-08-01 15:48:49] received data: 0b b6 00 08 42 2f 3e 18 00 00 43 0f 9f 44 00 00 00
try: 58
[Teltonika] [2018-08-01 15:48:49] received data: 00 00 00 01 64 f5 98 e7 60 00 0b df d7 48 1d de 8a
try: 59
[Teltonika] [2018-08-01 15:48:49] received data: c7 00 eb 00 9f 08 00 06 00 0c 06 ef 00 f0 01 50 01
try: 60
[Teltonika] [2018-08-01 15:48:49] received data: 15 04 c8 00 45 01 06 b5 00 10 b6 00 0d 42 2f 47 18
try: 61
[Teltonika] [2018-08-01 15:48:50] received data: 00 05 43 0f 89 44 00 00 00 00 10 00 00 90 d8
try: 62
