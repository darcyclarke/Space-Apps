(function() {
  var Asteroid, Game, MINERALS, MINERAL_TOTAL, Player, app, express, game, initGame, io, randomInt, server;

  MINERAL_TOTAL = 1000;

  MINERALS = ['water', 'carbon', 'nickel', 'iron', 'silicon', 'olivine'];

  Asteroid = function(size) {
    this.minerals = {
      water: size,
      carbon: size,
      nickel: size,
      iron: size,
      silicon: size,
      olivine: size
    };
    this.totalSize = function() {
      var mineral, _i, _len;
      size = 0;
      for (_i = 0, _len = minerals.length; _i < _len; _i++) {
        mineral = minerals[_i];
        size += this[mineral];
      }
      return size;
    };
    this.isEmpty = function() {
      return this.totalSize <= 0;
    };
    this.presentMinerals = function() {
      var mineral, minerals, _i, _len, _ref;
      minerals = [];
      _ref = this.minerals;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mineral = _ref[_i];
        if (this.minerals[mineral] > 0) {
          minerals.push(mineral);
        }
      }
      return minerals;
    };
    this.loseMineral = function(mineral, amount) {
      return this[mineral] -= amount;
    };
  };

  Player = function() {
    this.drillPower = 0;
    this.minerals = {
      water: 0,
      carbon: 0,
      nickel: 0,
      iron: 0,
      silicon: 0,
      olivine: 0
    };
    this.findMineral = function(mineral, amount) {
      return this.minerals[mineral] += amount;
    };
  };

  Game = function(asteroidSize) {
    this.isOver = false;
    this.asteroid = new Asteroid(MINERAL_TOTAL);
    this.players = {
      1: new Player(),
      2: new Player(),
      3: new Player(),
      4: new Player()
    };
    this.update = function(playerId, drillPower) {
      var amount, mineral, minerals;
      if (!this.asteroid.isEmpty()) {
        return this.isOver = true;
      } else {
        minerals = game.asteroid.presentMinerals();
        mineral = minerals[randomInt(minerals.length)];
        amount = randomInt(drillPower);
        game.asteroid.loseMineral(mineral, amount);
        return game.players[playerId].findMineral(mineral, amount);
      }
    };
  };

  game = new Game(MINERAL_TOTAL);

  express = require("express");

  app = require("express")();

  server = require("http").createServer(app);

  io = require("socket.io").listen(server);

  app.use('/assets', express["static"](__dirname + '/assets'));

  server.listen(8000);

  app.get("/", function(req, res) {
    res.sendfile(__dirname + "/index.html");
  });

  io.sockets.on("connection", function(socket) {
    socket.on('start', function(data) {
      console.log("START!");
      return initGame();
    });
    socket.on('drill', function(data) {
      var drillPower, playerId;
      console.log("DRILL!");
      console.log(data);
      if (data) {
        playerId = data["playerID"];
        drillPower = parseInt(data["drillPower"]);
        if (playerId && drillPower) {
          game.update(playerId, drillPower);
          socket.emit('update-game', game);
          return console.log(game);
        }
      }
    });
  });

  initGame = function() {
    return game = new Game(MINERAL_TOTAL);
  };

  randomInt = function(max) {
    return Math.floor(Math.random() * (max + 1));
  };

}).call(this);
