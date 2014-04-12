game =
  asteroid: 0
  players: 
    1:
      drillPower: 0
      minerals: 
        iron: 0
    2: 
      drillPower: 0
      minerals: 
        iron: 0
    3: 
      drillPower: 0
      minerals: 
        iron: 0
    4: 
      drillPower: 0
      minerals: 
        iron: 0

express = require("express")
app = require("express")()
server = require("http").createServer(app)
io = require("socket.io").listen(server)

app.use('/assets', express.static(__dirname + '/assets'))

server.listen 8000

app.get "/", (req, res) ->
  res.sendfile __dirname + "/index.html"
  return

io.sockets.on "connection", (socket) ->

  # -- events ---------------------------------------------------------------

  socket.on 'start', (data) -> 
    console.log("START!")
    initGame()

  socket.on 'drill', (data) ->
    console.log("DRILL!")
    console.log(data)
    updateGame(data)
    socket.emit('update-game', game)
    console.log(game)

  return

# -- methods ----------------------------------------------------------------

updateGame = (data) ->
  if data
    playerId = data["playerID"]
    drillPower = data["drillPower"]

    if playerId && drillPower
      game["asteroid"] += drillPower
      game["players"][playerId]["drillPower"] += drillPower

initGame = () -> 
  game =
    asteroid: 0
    players: 
      1:
        drillPower: 0
        minerals: 
          iron: 0
      2: 
        drillPower: 0
        minerals: 
          iron: 0
      3: 
        drillPower: 0
        minerals: 
          iron: 0
      4: 
        drillPower: 0
        minerals: 
          iron: 0
