(function() {
  var socket;

  socket = io.connect('http://localhost:8000');

  socket.on('news', function(data) {
    console.log(data);
    return socket.emit('my other event', {
      my: 'data'
    });
  });

}).call(this);
