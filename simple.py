
from tornado.ioloop import IOLoop
from tornado.httpclient import AsyncHTTPClient

io = IOLoop.instance()
io.make_current()

count = 0

def handle_request(response):
  global count, io

  if response.error:
    print "Error: %s\n" % response.error
  else:
    print "%r\n" % response

  count += 1
  if count == 100:
    io.stop()    

AsyncHTTPClient.configure("tornado.curl_httpclient.CurlAsyncHTTPClient")
client = AsyncHTTPClient()

for _ in range(0, 100):
  client.fetch("http://localhost:8080/", handle_request)

io.start()

