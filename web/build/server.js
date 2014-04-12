(function() {
  var Game, Player, app, defaultAsteroidSize, express, game, initGame, io, minerals, randomInt, server, updatePlayer;

  defaultAsteroidSize = 1000;

  minerals = ['water', 'carbon', 'nickel', 'iron', 'silicon', 'olivine'];

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
  };

  Player.prototype.findMineral = function(drillPower) {
    var mineral, power;
    power = randomInt(drillPower);
    mineral = minerals[randomInt(minerals.length)];
    return this.minerals[mineral] += power;
  };

  Game = function(asteroidSize) {
    this.asteroid = asteroidSize;
    this.players = {
      1: new Player(),
      2: new Player(),
      3: new Player(),
      4: new Player()
    };
  };

  game = new Game(defaultAsteroidSize);

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
      return console.log("START!");
    });
    socket.on('drill', function(data) {
      var drillPower, playerId;
      console.log("DRILL!");
      console.log(data);
      playerId = data["playerID"];
      drillPower = parseInt(data["drillPower"]);
      updatePlayer(data);
      socket.emit('update-game', game);
      return console.log(game);
    });
  });

  updatePlayer = function(data) {
    var drillPower, playerId;
    if (data) {
      playerId = data["playerID"];
      drillPower = parseInt(data["drillPower"]);
      if (playerId && drillPower) {
        game["asteroid"] -= drillPower;
        game["players"][playerId]["drillPower"] += drillPower;
        return game["players"][playerId].findMineral(drillPower);
      }
    }
  };

  initGame = function() {
    return game = new Game(defaultAsteroidSize);
  };

  randomInt = function(max) {
    return Math.floor(Math.random() * (max + 1));
  };

}).call(this);
