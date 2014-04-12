(function() {
  var app, express, http, io, server;

  express = require('express');

  app = express();

  http = require('http');

  server = http.createServer(app);

  io = require('socket.io').listen(server);

  app.use('/assets', express["static"](__dirname + '/assets'));

  app.get('/', function(req, res) {
    return res.sendfile(__dirname + '/index.html');
  });

  io.sockets.on('connection', function(socket) {
    socket.emit('news', {
      hello: 'world'
    });
    return socket.on('my something', function(data) {
      return console.log(data);
    });
  });

  http.createServer(app).listen(8000);

}).call(this);
