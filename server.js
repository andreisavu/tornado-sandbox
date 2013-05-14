
var http = require('http');
var fs = require('fs');

var fileName = process.argv[2] || 'response.json'
var response = fs.readFileSync(fileName)

var port = 8080
var responseDelayMs = 3000

http.createServer(function (req, res) {
  setTimeout(function() { 
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(response);
  }, responseDelayMs);
}).listen(port);

console.log("Listening on port " + port + " ...");

