(function() {
  var Asteroid, Game, Player;

  Game = (function() {
    function Game(socket) {
      this.log('Game Started');
      this.socket = socket;
      this.won = false;
      this.time = 90;
      this.currentScreen = 0;
      this.screenDelay = 2000;
      this.colors = ['red', 'blue', 'green', 'yellow'];
      this.$game = $('.game');
      this.$countdown = $('.countdown');
      this.$screens = $('.screen');
      this.asteroid = new Asteroid();
      this.players = this.colors.forEach(function(k, v) {
        return new Player(k);
      });
      this.socket.on('scarceMineralCollected', function(data) {
        return this.addMineral(data);
      });
      this.socket.on('commonMineralCollected', function(data) {
        return this.addMineral(data);
      });
      this.socket.on('updateGame', function(data) {
        return this.updateGame(data);
      });
      this.nextScreen();
    }

    Game.prototype.log = function(message, data) {
      if (data == null) {
        data = this;
      }
      return console.log('LOG: ' + message, data);
    };

    Game.prototype.nextScreen = function() {
      var increment, x;
      x = this.currentScreen;
      this.screenDelay = this.$screens.eq(x).data('delay') || this.screenDelay;
      increment = (function(_this) {
        return function() {
          _this.currentScreen = _this.currentScreen + 1;
          return _this.nextScreen();
        };
      })(this);
      this.$screens.css({
        opacity: 0
      }).eq(x).css({
        opacity: 1
      });
      if ((x + 1) >= this.$screens.length) {
        return;
      }
      if (this.$screens.eq(x) === this.$game) {
        return this.startCoundown();
      } else {
        return setTimeout(increment, this.screenDelay);
      }
    };

    Game.prototype.startCountdown = function() {
      this.log('Countdown Started');
      this.socket.emit('start');
      ({
        increment: (function(_this) {
          return function() {
            _this.time = _this.time - 1;
            _this.$countdown.text(_this.time);
            if (_this.time <= 0) {
              clearInterval(_this.timer);
              _this.socket.emit('timeUp');
            }
          };
        })(this)
      });
      return this.counter = setInterval(increment, 1000);
    };

    Game.prototype.updateGame = function(data) {
      this.log('Game Update', data);
      if (data.isOver) {
        this.won = data.didWin;
        return this.log('Game Over');
      }
    };

    return Game;

  })();

  Player = (function() {
    Player.prototype.x = 0;

    Player.prototype.y = 0;

    function Player(color) {
      this.color = color;
      this.$player = $('.asteroids .' + color);
      this.$player_gui = $('.gui .' + color);
      this.$player_notifications = $('.notifications .' + color);
      this.$ship = this.$player.find('.ship');
      this.$minerals_overall = this.$player_gui.find('.overall .score');
      this.$minerals_abundant = this.$player_gui.find('.abundant .score');
      this.$minerals_common = this.$player_gui.find('.common .score');
      this.$minerals_rare = this.$player_gui.find('.rare .score');
    }

    Player.prototype.notification = function(data) {
      var $template, amount, element, name;
      name = data.name || '...';
      element = data.element || '...';
      amount = data.amount || 0;
      $template = $('<div class="notification cf rare"><p class="text"><strong>+' + amount + '</strong> ' + name + ' Gained - ' + element + '</p></div>');
      return $template.appendTo(this.player_notifications).show().delay(500).remove();
    };

    Player.prototype.update = function(data) {
      return console.log('player update', this.color, data);
    };

    return Player;

  })();

  Asteroid = (function() {
    Asteroid.prototype.x = 0;

    Asteroid.prototype.y = 0;

    function Asteroid() {
      this.$asteroid = $('.asteroids .asteroid');
    }

    return Asteroid;

  })();

  jQuery(function($) {
    var game, socket;
    window.socket = socket = io.connect('http://107.170.78.222:8000/');
    return window.game = game = new Game(socket);
  });

}).call(this);
