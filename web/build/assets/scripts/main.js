(function() {
  var socket;

  socket = io.connect('http://localhost:8000');

  socket.on('update-positions', function(data) {
    console.log(data);
    return $('h1').css({
      top: data.y,
      left: data.x
    });
  });

}).call(this);
