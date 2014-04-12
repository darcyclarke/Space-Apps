# ===========================================================================
# constants
# ===========================================================================

MINERAL_TOTAL = 1000
MINERALS = ['water', 'carbon', 'nickel', 'iron', 'silicon', 'olivine']

# ===========================================================================
# class definitions
# ===========================================================================

# -- asteroid ---------------------------------------------------------------

Asteroid = (size) -> 
  this.minerals = 
    water: size
    carbon: size
    nickel: size
    iron: size
    silicon: size
    olivine: size

Asteroid::totalSize = () -> 
  size = 0
  for mineral in minerals
    size += this[mineral]

  return size

Asteroid::isEmpty = () ->
  return totalSize <= 0

# -- player -----------------------------------------------------------------

Player = () -> 
  this.drillPower = 0
  this.minerals = 
    water: 0
    carbon: 0
    nickel: 0
    iron: 0
    silicon: 0
    olivine: 0

  return

Player::findMineral = (drillPower) -> 
  power = randomInt(drillPower)
  mineral = minerals[randomInt(minerals.length)]

  this.minerals[mineral] += power

# -- game -------------------------------------------------------------------

Game = (asteroidSize) ->
  this.isOver = false
  this.asteroid = new Asteroid(MINERAL_TOTAL)
  this.players = 
    1: new Player()
    2: new Player()
    3: new Player()
    4: new Player()

  return

Game::update = (playerId, drillPower) -> 
  if !this.asteroid.isEmpty()
    this.isOver = true
  else

      game["players"][playerId]["drillPower"] += drillPower

      game["players"][playerId].findMineral(drillPower)

# ===========================================================================
# config
# ===========================================================================

game = new Game(defaultAsteroidSize)

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

  # ==========================================================================
  # events
  # ==========================================================================

  socket.on 'start', (data) -> 
    console.log("START!")
    # initGame()

  socket.on 'drill', (data) ->
    console.log("DRILL!")
    console.log(data)
    if data
      playerId = data["playerID"]
      drillPower = parseInt(data["drillPower"])
      if playerId && drillPower
        game.update(playerId, drillPower)
        socket.emit('update-game', game)
        console.log(game)

  return

# ===========================================================================
# global methods
# ===========================================================================

initGame = () -> 
  game = new Game(defaultAsteroidSize)

randomInt = (max) ->
  Math.floor(Math.random() * (max + 1))
