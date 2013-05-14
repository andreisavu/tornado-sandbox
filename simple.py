
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
  if count == 1000:
    io.stop()    

AsyncHTTPClient.configure("tornado.curl_httpclient.CurlAsyncHTTPClient")
client = AsyncHTTPClient()

for _ in range(0,1000):
  client.fetch("http://httpbin.org/delay/3", handle_request)

io.start()

