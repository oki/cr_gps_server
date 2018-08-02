require "./src/*"

server = GeneralServer.new

server.register_protocol(Protocols::TeltonikaHandler, 5024)

server.run
