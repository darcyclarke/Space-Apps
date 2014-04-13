(function() {
  var randomInt, socket;

  randomInt = function(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  socket = io.connect('http://localhost:8000');

  socket.on('scarceMineralCollected', function(data) {
    console.log("SCARCE");
    return $('span.scarce-mineral').html(JSON.stringify(data));
  });

  socket.on('commonMineralCollected', function(data) {
    console.log("COMMON");
    return $('span.common-mineral').html(JSON.stringify(data));
  });

  socket.on('updateGame', function(data) {
    var json;
    json = data;
    console.log("===> ", json);
    $('span.game').html("isOver: " + JSON.stringify(json["isOver"]) + ", didWin: " + JSON.stringify(json["didWin"]));
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

  $('button.time-up').on('click', function() {
    return socket.emit('timeUp');
  });

  window.socket = socket;

  jQuery(function($) {
    var $screens, callback, delay, len, roll, x;
    $screens = $('.screen');
    len = $screens.length;
    delay = 2000;
    x = 0;
    callback = function() {
      x = x + 1;
      return roll();
    };
    roll = function() {
      delay = $screens.eq(x).data('delay') || delay;
      $screens.css({
        opacity: 0
      }).delay(1000).eq(x).css({
        opacity: 1
      });
      if ((x + 1) >= len) {
        return;
      }
      return setTimeout(callback, delay);
    };
    return roll();
  });

}).call(this);
