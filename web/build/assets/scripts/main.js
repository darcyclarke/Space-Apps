(function() {
  var socket;

  socket = io.connect('http://localhost:8000');

  socket.on('update-positions', function(data) {
    console.log(data);
    return $('h1').css({
      top: data["player1"].y,
      left: data["player1"].x
    });
  });

  window.socket = socket;

}).call(this);
