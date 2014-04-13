(function() {
  var Asteroid, Game, Player;

  Game = (function() {
    function Game(socket) {
      console.log('Game Started');
      this.socket = socket;
      this.won = false;
      this.time = 90;
      this.currentScreen = 0;
      this.screenDelay = 2000;
      this.$game = $('.game');
      this.$countdown = $('.countdown');
      this.$screens = $('.screen');
      this.asteroid = new Asteroid();
      this.players = [];
      this.players.push(new Player('red'));
      this.players.push(new Player('blue'));
      this.players.push(new Player('green'));
      this.players.push(new Player('yellow'));
      this.socket.on('scarceMineralCollected', (function(_this) {
        return function(data) {
          var player;
          player = _this.getPlayer(data.playerID);
          console.log('Found Rare Mineral!', player);
          return _this.players[player].notification('rare', data);
        };
      })(this));
      this.socket.on('commonMineralCollected', (function(_this) {
        return function(data) {
          var player;
          player = _this.getPlayer(data.playerID);
          console.log('Found Common Mineral!', player);
          return _this.players[player].notification('common', data);
        };
      })(this));
      this.socket.on('abundantMineralCollected', (function(_this) {
        return function(data) {
          var player;
          player = _this.getPlayer(data.playerID);
          console.log('Found Abundant Mineral!', player);
          return _this.players[player].notification('abundant', data);
        };
      })(this));
      this.socket.on('updateGame', (function(_this) {
        return function(data) {
          return _this.updateGame(data);
        };
      })(this));
      this.nextScreen();
    }

    Game.prototype.updateGame = function(data) {
      console.log('Game Update!', data);
      if (data.isOver) {
        this.won = data.didWin;
        if (this.won) {
          this.$screens.css({
            opacity: 0
          }).filter('.skyline').css({
            opacity: 1
          });
        } else {
          this.$screens.css({
            opacity: 0
          }).filter('.end').css({
            opacity: 1
          });
        }
        return console.log('Game Over!');
      }
    };

    Game.prototype.getPlayer = function(id) {
      if (id === 'player1') {
        return 0;
      }
      if (id === 'player2') {
        return 1;
      }
      if (id === 'player3') {
        return 2;
      }
      if (id === 'player4') {
        return 3;
      }
    };

    Game.prototype.startCountdown = function() {
      var increment;
      console.log('Countdown Started');
      this.socket.emit('start');
      increment = (function(_this) {
        return function() {
          _this.time = _this.time - 1;
          _this.$countdown.text(_this.time);
          if (_this.time <= 10) {
            $('.asteroids .asteroid').css({
              transform: 'scale(0.1)'
            });
            $('.asteroids').css({
              top: '+=375px'
            });
            $('.earth img').css({
              width: 'scale(4)'
            });
          }
          if (_this.time <= 20) {
            $('.asteroids .asteroid').css({
              transform: 'scale(0.25)'
            });
            $('.asteroids').css({
              top: '+=300px'
            });
            $('.earth img').css({
              width: 'scale(3)'
            });
          }
          if (_this.time <= 30) {
            $('.asteroids .asteroid').css({
              transform: 'scale(0.5)'
            });
            $('.asteroids').css({
              top: '+=225px'
            });
            $('.earth img').css({
              width: 'scale(2)'
            });
          }
          if (_this.time <= 50) {
            $('.asteroids .asteroid').css({
              transform: 'scale(0.75)'
            });
            $('.asteroids').css({
              top: '+=150px'
            });
            $('.earth img').css({
              transform: 'scale(1.5)'
            });
          }
          if (_this.time <= 80) {
            $('.asteroids').css({
              transform: 'scale(0.9)'
            });
            $('.asteroids .asteroid').css({
              top: '+=75px'
            });
            $('.earth img').css({
              transform: 'scale(1.25)'
            });
          }
          if (_this.time <= 0) {
            console.log('time up!');
            clearInterval(_this.counter);
            return _this.socket.emit('timeUp');
          }
        };
      })(this);
      return this.counter = setInterval(increment, 1000);
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
      if (this.$screens.eq(x).hasClass('game')) {
        return this.startCountdown();
      } else {
        return setTimeout(increment, this.screenDelay);
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
      this.$minerals_rare = this.$player_gui.find('.scarce .score');
    }

    Player.prototype.notification = function(type, data) {
      var $template, amount, element, hide, name;
      if (type === 'common') {
        this.$minerals_common.css({
          width: '+=5%'
        });
      }
      if (type === 'rare') {
        this.$minerals_rare.css({
          width: '+=10%'
        });
      }
      if (type === 'abundant') {
        this.$minerals_abundant.css({
          width: '+=2.5%'
        });
      }
      if (type === 'rare' || type === 'abundant') {
        name = data.name || '...';
        element = data.element || '...';
        amount = data.amount || 0;
        $template = $('<div class="notification cf ' + type + '"><p class="text"><strong>+' + amount + '</strong> ' + name + ' Gained - ' + element + '</p></div>');
        $template.appendTo(this.$player_notifications).css({
          opacity: '1'
        });
        hide = function() {
          return $template.animate({
            top: '+=10px',
            opacity: '0'
          }, 200, function() {
            return $(this).remove();
          });
        };
        return setTimeout(hide, 100);
      }
    };

    Player.prototype.addMineral = function(data) {
      return console.log(data);
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
    window.socket = socket = io.connect('http://192.168.106.50:8000');
    return window.game = game = new Game(socket);
  });

}).call(this);
