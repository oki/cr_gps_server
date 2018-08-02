require "./src/*"

server = GeneralServer.new

server.register_protocol(Protocols::Gt06Handler, 5022)
server.register_protocol(Protocols::Tk103Handler, 5023)
# server.register_protocol(Protocols::TeltonikaHandler, 5024)

server.run
