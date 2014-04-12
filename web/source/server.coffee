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

  this.totalSize = () -> 
    size = 0
    for mineral in MINERALS
      size += this.minerals[mineral]

    return size

  this.isEmpty = () ->
    return this.totalSize() <= 0

  this.presentMinerals = () -> 
    minerals = []
    for mineral in MINERALS
      if this.minerals[mineral] > 0
        minerals.push mineral

    return minerals

  this.loseMineral = (mineral, amount) ->
    this.minerals[mineral] -= amount

  return

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

  this.findMineral = (mineral, amount) -> 
    this.minerals[mineral] += amount

  return

# -- game -------------------------------------------------------------------

Game = (asteroidSize) ->
  this.isOver = false
  this.asteroid = new Asteroid(MINERAL_TOTAL)
  this.players = 
    1: new Player()
    2: new Player()
    3: new Player()
    4: new Player()

  this.update = (playerId, drillPower) -> 
    if this.asteroid.isEmpty()
      this.isOver = true
    else
      minerals = game.asteroid.presentMinerals()
      mineral = minerals[randomInt(minerals.length)]
      amount = randomInt(drillPower)
      
      game.asteroid.loseMineral(mineral, amount)
      game.players[playerId].findMineral(mineral, amount)

  return

# ===========================================================================
# config
# ===========================================================================

game = new Game(MINERAL_TOTAL)

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
    initGame()

  socket.on 'drill', (data) ->
    console.log("DRILL!")
    console.log(data)
    if data
      playerId = data["playerID"]
      drillPower = parseInt(data["drillPower"])
      if playerId && drillPower
        game.update(playerId, drillPower)
        socket.emit('update-game', JSON.stringify(game))
        console.log("=====> ", JSON.stringify(game))

  return

# ===========================================================================
# global methods
# ===========================================================================

initGame = () -> 
  game = new Game(MINERAL_TOTAL)

randomInt = (max) ->
  Math.floor(Math.random() * (max + 1))
