
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
    print "%s: %r" % (count, response)

  count += 1
  if count == 5000:
    io.stop()    

AsyncHTTPClient.configure("tornado.curl_httpclient.CurlAsyncHTTPClient")
client = AsyncHTTPClient(max_clients = 1000)

for _ in range(0, 5000):
  client.fetch("http://localhost:8080/", handle_request)

io.start()

