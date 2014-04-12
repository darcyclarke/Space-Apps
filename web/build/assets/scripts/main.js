(function() {
  var randomInt, socket;

  randomInt = function(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  socket = io.connect('http://localhost:8000');

  socket.on('update-game', function(data) {
    return console.log(data);
  });

  $('button.click-me').on('click', function() {
    return socket.emit('drill', {
      'playerID': randomInt(1, 4),
      'drillPower': 10
    });
  });

  window.socket = socket;

}).call(this);
