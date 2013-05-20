
from tornado.ioloop import IOLoop
from tornado.httpclient import AsyncHTTPClient
from tornado.httpclient import HTTPRequest

io = IOLoop.instance()
io.make_current()

AsyncHTTPClient.configure("tornado.curl_httpclient.CurlAsyncHTTPClient")
client = AsyncHTTPClient(max_clients = 300)

batch_size = 10000
count = 0
errors = 0

def handle_request(response):
  global io, client, count, errors, batch_size

  if response.error:
    print "Error: %rn" % response
    errors += 1
  else:
    print "%s: %r" % (count, response)

  count += 1
  if count == batch_size:
    print "Error count: %d" % errors
    client.close()  # we should probably close & re-create the client for each batch
    io.stop()    

url = 'http://localhost:8080/'

options = {
  'proxy_host': 'localhost',
  'proxy_port': 3128,
  'connect_timeout': 3,
  'request_timeout': 10,
  'max_redirects': 3,
  'user_agent': 'My custom UA',
  'use_gzip': True,
  'validate_cert': False
}

for _ in range(0, batch_size):
  client.fetch(HTTPRequest(url, **options), handle_request)  

io.start()

