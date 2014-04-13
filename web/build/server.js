(function() {
  var ABUNDANT_MINERALS, ABUNDANT_TOTAL, Asteroid, COMMON_DIFFICULTY_LEVEL, COMMON_MINERALS, COMMON_TOTAL, ELEMENTS, Game, MINERALS, Player, SCARCE_DIFFICULTY_LEVEL, SCARCE_MINERALS, SCARCE_TOTAL, app, express, game, initGame, io, isAbundant, isCommon, isScarce, lastAmount, lastMineral, mineralType, randomInt, server;

  ABUNDANT_TOTAL = 100000;

  COMMON_TOTAL = 100000;

  SCARCE_TOTAL = 50000;

  ABUNDANT_MINERALS = ['iron', 'carbon', 'silicon'];

  COMMON_MINERALS = ['water', 'nickel', 'cobalt', 'titanium', 'magnesium'];

  SCARCE_MINERALS = ['platinum', 'gold', 'silver'];

  ELEMENTS = {
    'iron': 'Fe',
    'carbon': 'C',
    'silicon': 'Si',
    'water': 'H20',
    'nickel': 'Ni',
    'cobalt': 'Co',
    'titanium': 'Ti',
    'magnesium': 'Mg',
    'platinum': 'Pt',
    'gold': 'Au',
    'silver': 'Ag'
  };

  COMMON_DIFFICULTY_LEVEL = 2;

  SCARCE_DIFFICULTY_LEVEL = 3;

  MINERALS = ABUNDANT_MINERALS.concat(COMMON_MINERALS, SCARCE_MINERALS);

  lastMineral = null;

  lastAmount = null;

  Asteroid = function() {
    this.minerals = {
      iron: ABUNDANT_TOTAL,
      carbon: ABUNDANT_TOTAL,
      silicon: ABUNDANT_TOTAL,
      water: COMMON_TOTAL,
      nickel: COMMON_TOTAL,
      cobalt: COMMON_TOTAL,
      titanium: COMMON_TOTAL,
      magnesium: COMMON_TOTAL,
      platinum: SCARCE_TOTAL,
      gold: SCARCE_TOTAL,
      silver: SCARCE_TOTAL
    };
    this.totalSize = function() {
      var mineral, size, _i, _len;
      size = 0;
      for (_i = 0, _len = MINERALS.length; _i < _len; _i++) {
        mineral = MINERALS[_i];
        size += this.minerals[mineral];
      }
      return size;
    };
    this.isEmpty = function() {
      return this.totalSize() <= 0;
    };
    this.presentMinerals = function() {
      var mineral, minerals, _i, _len;
      minerals = [];
      for (_i = 0, _len = MINERALS.length; _i < _len; _i++) {
        mineral = MINERALS[_i];
        if (this.minerals[mineral] > 0) {
          minerals.push(mineral);
        }
      }
      return minerals;
    };
    this.loseMineral = function(mineral, amount) {
      return this.minerals[mineral] -= amount;
    };
  };

  Player = function() {
    this.points = 0;
    this.minerals = {
      iron: 0,
      carbon: 0,
      silicon: 0,
      water: 0,
      nickel: 0,
      cobalt: 0,
      titanium: 0,
      magnesium: 0,
      platinum: 0,
      gold: 0,
      silver: 0
    };
    this.findMineral = function(mineral, amount) {
      this.minerals[mineral] += amount;
      if (isScarce(mineral)) {
        return this.points += 3;
      } else if (isCommon(mineral)) {
        return this.points += 2;
      } else {
        return this.points += 1;
      }
    };
  };

  Game = function() {
    this.isOver = false;
    this.didWin = false;
    this.numPlayers = 0;
    this.asteroid = new Asteroid();
    this.players = {
      player1: new Player(),
      player2: new Player(),
      player3: new Player(),
      player4: new Player()
    };
    this.update = function(playerId, drillPower) {
      var amount, i, mineral, minerals;
      if (this.asteroid.isEmpty()) {
        this.didWin = true;
        return this.isOver = true;
      } else {
        minerals = game.asteroid.presentMinerals();
        mineral = minerals[randomInt(minerals.length - 1)];
        amount = drillPower * 10;
        i = 0;
        while (isCommon(mineral) && i < COMMON_DIFFICULTY_LEVEL) {
          mineral = minerals[randomInt(minerals.length - 1)];
          i++;
        }
        i = 0;
        while (isScarce(mineral) && i < SCARCE_DIFFICULTY_LEVEL) {
          mineral = minerals[randomInt(minerals.length - 1)];
          i++;
        }
        if (game.asteroid.minerals[mineral] < amount) {
          amount = game.asteroid.minerals[mineral];
        }
        game.asteroid.loseMineral(mineral, amount);
        game.players[playerId].findMineral(mineral, amount);
        lastMineral = mineral;
        return lastAmount = amount;
      }
    };
  };

  game = new Game();

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
      console.log("START");
      initGame();
      return io.sockets.emit('updateGame', game);
    });
    socket.on('clientRegistered', function(data) {
      console.log("CLIENT REGISTERED ==> ", data);
      return io.sockets.emit('updateGame', game);
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
          io.sockets.emit('updateGame', game);
          if (isScarce(lastMineral)) {
            io.sockets.emit('scarceMineralCollected', {
              name: lastMineral,
              element: ELEMENTS[lastMineral],
              playerID: playerId,
              amount: lastAmount
            });
          } else if (isCommon(lastMineral)) {
            io.sockets.emit('commonMineralCollected', {
              name: lastMineral,
              element: ELEMENTS[lastMineral],
              playerID: playerId,
              amount: lastAmount
            });
          } else if (isAbundant(lastMineral)) {
            io.sockets.emit('abundantMineralCollected', {
              name: lastMineral,
              element: ELEMENTS[lastMineral],
              playerID: playerId,
              amount: lastAmount
            });
          }
          return console.log("=====> ", JSON.stringify(game));
        }
      }
    });
    socket.on('timeUp', function(data) {
      console.log("TIME UP");
      game.isOver = true;
      return io.sockets.emit('updateGame', game);
    });
  });

  mineralType = function(mineral) {
    if (isScarce(mineral)) {
      return "scarce";
    } else if (isCommon(mineral)) {
      return "common";
    } else {
      return "abundant";
    }
  };

  initGame = function() {
    return game = new Game();
  };

  isScarce = function(mineral) {
    return SCARCE_MINERALS.indexOf(mineral) > -1;
  };

  isCommon = function(mineral) {
    return COMMON_MINERALS.indexOf(mineral) > -1;
  };

  isAbundant = function(mineral) {
    return ABUNDANT_MINERALS.indexOf(mineral) > -1;
  };

  randomInt = function(max) {
    return Math.floor(Math.random() * (max + 1));
  };

}).call(this);
