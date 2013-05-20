
import json

from tornado.ioloop import IOLoop, PeriodicCallback

from tornado.httpclient import AsyncHTTPClient
from tornado.httpclient import HTTPRequest

class RequestHandlerWithStats(object):
  """ Receive the response, parse the json and continue """

  def __init__(self):
    self._count = 0
    self._errors = 0

  def __call__(self, response):
    if response.error:
      self._errors += 1
      response.rethrow() # propagate error - should but message back

    results = json.loads(response.body)
    print "%s: %r" % (self._count, len(results['data']))

    self._count += 1

  def __repr__(self):
    return "<RequestHandler processed=%s errors=%s>" % (self._count, self._errors)

URL = 'http://localhost:8080/'

OPTIONS = {
  'proxy_host': 'localhost',
  'proxy_port': 3128,
  'connect_timeout': 3,
  'request_timeout': 10,
  'max_redirects': 3,
  'user_agent': 'My custom UA',
  'use_gzip': True,
  'validate_cert': False
}

AsyncHTTPClient.configure("tornado.curl_httpclient.CurlAsyncHTTPClient")
client = AsyncHTTPClient(max_clients = 300)
# max_clients ~ number of proxy servers

handler = RequestHandlerWithStats()

def producer():
  global client, URL, OPTIONS, handler

  print "Adding a new batch to the queue ..."
  for _ in xrange(0, 1000):
    client.fetch(HTTPRequest(URL, **OPTIONS), handler)

PeriodicCallback(producer, 10000).start()

IOLoop().instance().start()


