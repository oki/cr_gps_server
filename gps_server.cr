require "./src/*"

server = GeneralServer.new

server.register_protocol(Protocols::Tk103Client, 5023)
server.register_protocol(Protocols::Gt06Client, 5022)

server.run
