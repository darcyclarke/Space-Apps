(function() {
  var randomInt, socket;

  randomInt = function(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  socket = io.connect('http://localhost:8000');

  socket.on('updateGame', function(data) {
    var json;
    json = data;
    console.log("===> ", json);
    $('span.game').html("isOver: " + JSON.stringify(json["isOver"]));
    $('span.asteroid').html(JSON.stringify(json["asteroid"]));
    $('span.player1').html(JSON.stringify(json["players"]["player1"]));
    $('span.player2').html(JSON.stringify(json["players"]["player2"]));
    $('span.player3').html(JSON.stringify(json["players"]["player3"]));
    return $('span.player4').html(JSON.stringify(json["players"]["player4"]));
  });

  $('button.click-me').on('click', function() {
    return socket.emit('drill', {
      'playerID': "player" + randomInt(1, 4),
      'drillPower': randomInt(0, 1000)
    });
  });

  $('button.start').on('click', function() {
    return socket.emit('start');
  });

  window.socket = socket;

}).call(this);
