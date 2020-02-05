require "webrick"

server = WEBrick::HTTPServer.new(Port: 8000, AccessLog: [])
server.mount_proc('/') do |request, response|
  response.status = 200
  response.content_type = "text/html"
  response.body = "<html><body>success</body></html>"
end

Signal.trap('INT') { server.shutdown }
server.start

