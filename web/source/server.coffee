# ===========================================================================
# constants
# ===========================================================================

ABUNDANT_TOTAL = 10000
COMMON_TOTAL = 5000
SCARCE_TOTAL = 1000

ABUNDANT_MINERALS = ['iron', 'carbon', 'silicon']
COMMON_MINERALS = ['water', 'nickel', 'cobalt', 'titanium', 'magnesium']
SCARCE_MINERALS = ['platinum', 'gold', 'silver']

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
}

COMMON_DIFFICULTY_LEVEL = 2
SCARCE_DIFFICULTY_LEVEL = 3

MINERALS = ABUNDANT_MINERALS.concat(COMMON_MINERALS, SCARCE_MINERALS)

# ===========================================================================
# global variables
# ===========================================================================

lastMineral = null
lastAmount = null

# ===========================================================================
# class definitions
# ===========================================================================

# -- asteroid ---------------------------------------------------------------

Asteroid = () -> 
  this.minerals = 
    iron: ABUNDANT_TOTAL
    carbon: ABUNDANT_TOTAL
    silicon: ABUNDANT_TOTAL
    water: COMMON_TOTAL
    nickel: COMMON_TOTAL
    cobalt: COMMON_TOTAL
    titanium: COMMON_TOTAL
    magnesium: COMMON_TOTAL
    platinum: SCARCE_TOTAL
    gold: SCARCE_TOTAL
    silver: SCARCE_TOTAL

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
  this.minerals = 
    iron: 0
    carbon: 0
    silicon: 0
    water: 0
    nickel: 0
    cobalt: 0
    titanium: 0
    magnesium: 0
    platinum: 0
    gold: 0
    silver: 0

  this.findMineral = (mineral, amount) -> 
    this.minerals[mineral] += amount

  return

# -- game -------------------------------------------------------------------

Game = () ->
  this.isOver = false
  this.didWin = false
  this.numPlayers = 0
  this.asteroid = new Asteroid()
  this.players = 
    player1: new Player()
    player2: new Player()
    player3: new Player()
    player4: new Player()

  this.update = (playerId, drillPower) -> 
    if this.asteroid.isEmpty()
      this.didWin = true
      this.isOver = true
    else
      minerals = game.asteroid.presentMinerals()
      mineral = minerals[randomInt(minerals.length-1)]
      amount = (drillPower)*10

      # it's a little harder to get scarce or common resources
      i = 0
      while isCommon(mineral) && i < COMMON_DIFFICULTY_LEVEL
        mineral = minerals[randomInt(minerals.length-1)]
        i++

      i = 0
      while isScarce(mineral) && i < SCARCE_DIFFICULTY_LEVEL
        mineral = minerals[randomInt(minerals.length-1)]
        i++
        
      if game.asteroid.minerals[mineral] < amount
        amount = game.asteroid.minerals[mineral]

      game.asteroid.loseMineral(mineral, amount)
      game.players[playerId].findMineral(mineral, amount)

      lastMineral = mineral
      lastAmount = amount

  return

# ===========================================================================
# config
# ===========================================================================

game = new Game()

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
    console.log("START")
    initGame()
    io.sockets.emit('updateGame', game)

  socket.on 'clientRegistered', (data) -> 
    console.log("CLIENT REGISTERED ==> ", data)
    io.sockets.emit('updateGame', game)

  socket.on 'drill', (data) ->
    console.log("DRILL!")
    console.log(data)
    if data
      playerId = data["playerID"]
      drillPower = parseInt(data["drillPower"])
      if playerId && drillPower
        game.update(playerId, drillPower)
        io.sockets.emit('updateGame', game)

        if isScarce(lastMineral)
          io.sockets.emit('scarceMineralCollected', {
            name: lastMineral, 
            element: ELEMENTS[lastMineral],
            playerID: playerId, 
            amount: lastAmount
          })
        else if isCommon(lastMineral)
          io.sockets.emit('commonMineralCollected', {
            mineral: lastMineral, 
            element: ELEMENTS[lastMineral],
            playerID: playerId, 
            amount: lastAmount
          })

        console.log("=====> ", JSON.stringify(game))

  socket.on 'timeUp', (data) -> 
    console.log("TIME UP")
    game.isOver = true
    io.sockets.emit('updateGame', game)

  return

# ===========================================================================
# global methods
# ===========================================================================

mineralType = (mineral) -> 
  if isScarce(mineral)
    return "scarce"
  else if isCommon(mineral)
    return "common"
  else
    return "abundant"

initGame = () -> 
  game = new Game()

isScarce = (mineral) -> 
  SCARCE_MINERALS.indexOf(mineral) > -1

isCommon = (mineral) -> 
  COMMON_MINERALS.indexOf(mineral) > -1

isAbundant = (mineral) -> 
  ABUNDANT_MINERALS.indexOf(mineral) > -1

randomInt = (max) ->
  Math.floor(Math.random() * (max + 1))
