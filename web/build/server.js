(function() {
  var app, express, game, initGame, io, server, updateGame;

  game = {
    asteroid: 0,
    players: {
      1: {
        drillPower: 0,
        minerals: {
          iron: 0
        }
      },
      2: {
        drillPower: 0,
        minerals: {
          iron: 0
        }
      },
      3: {
        drillPower: 0,
        minerals: {
          iron: 0
        }
      },
      4: {
        drillPower: 0,
        minerals: {
          iron: 0
        }
      }
    }
  };

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
      console.log("DRILL!");
      console.log(data);
      updateGame(data);
      socket.emit('update-game', game);
      return console.log(game);
    });
  });

  updateGame = function(data) {
    var drillPower, playerId;
    if (data) {
      playerId = data["playerID"];
      drillPower = data["drillPower"];
      if (playerId && drillPower) {
        game["asteroid"] += drillPower;
        return game["players"][playerId]["drillPower"] += drillPower;
      }
    }
  };

  initGame = function() {
    return game = {
      asteroid: 0,
      players: {
        1: {
          drillPower: 0,
          minerals: {
            iron: 0
          }
        },
        2: {
          drillPower: 0,
          minerals: {
            iron: 0
          }
        },
        3: {
          drillPower: 0,
          minerals: {
            iron: 0
          }
        },
        4: {
          drillPower: 0,
          minerals: {
            iron: 0
          }
        }
      }
    };
  };

}).call(this);
