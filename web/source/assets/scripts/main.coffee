
# ---------------------------------------------------
# Game Class

class Game

    constructor: (socket) ->

      @log('Game Started')

      @socket         = socket
      @won            = false
      @time           = 90
      @currentScreen  = 0
      @screenDelay    = 2000
      @colors         = ['red', 'blue', 'green', 'yellow']
      @$game          = $('.game')
      @$countdown     = $('.countdown')
      @$screens       = $('.screen')
      @asteroid       = new Asteroid()
      @players        = @colors.forEach (k, v) -> new Player(k)

      @socket.on 'scarceMineralCollected', (data) ->
        @addMineral(data)

      @socket.on 'commonMineralCollected', (data) ->
        @addMineral(data)

      @socket.on 'updateGame', (data) ->
        @updateGame(data)

      @nextScreen()

    log: (message, data=@) ->
      console.log('LOG: ' + message, data)

    nextScreen: () ->
      x = @currentScreen
      @screenDelay = @$screens.eq(x).data('delay') or @screenDelay

      increment = () =>
        @currentScreen = @currentScreen + 1
        @nextScreen()

      @$screens.css( opacity: 0 ).eq(x).css( opacity: 1 )

      return if((x + 1)  >= @$screens.length)

      if(@$screens.eq(x) is @$game)
        @startCoundown()
      else
        setTimeout(increment, @screenDelay)

    startCountdown: () ->
      @log('Countdown Started')
      @socket.emit('start')

      increment: () =>
        @time = @time - 1
        @$countdown.text(@time)
        if(@time <= 0)
          clearInterval(@timer)
          @socket.emit('timeUp')
          return

      @counter = setInterval(increment, 1000)

    updateGame: (data) ->
      @log('Game Update', data)
      if(data.isOver)
        @won = data.didWin
        @log('Game Over')


# ---------------------------------------------------
# Player Class

class Player

    x: 0
    y: 0

    constructor: (color) ->
      @color                 = color
      @$player               = $('.asteroids .' + color)
      @$player_gui           = $('.gui .' + color)
      @$player_notifications = $('.notifications .' + color)
      @$ship                 = @$player.find('.ship')
      @$minerals_overall     = @$player_gui.find('.overall .score')
      @$minerals_abundant    = @$player_gui.find('.abundant .score')
      @$minerals_common      = @$player_gui.find('.common .score')
      @$minerals_rare        = @$player_gui.find('.rare .score')

    notification: (data) ->
      name          = data.name or '...'
      element       = data.element or '...'
      amount        = data.amount or 0
      $template     = $('<div class="notification cf rare"><p class="text"><strong>+' + amount+ '</strong> ' + name + ' Gained - ' + element + '</p></div>')
      $template.appendTo(@player_notifications).show().delay(500).remove()

    update: (data) ->
      console.log('player update', @color, data)

# ---------------------------------------------------
# Asteroid Class

class Asteroid

  x: 0
  y: 0

  constructor: () ->
    @$asteroid = $('.asteroids .asteroid')


# ---------------------------------------------------
# Setup Socket Connection & Game

jQuery ($) ->
  window.socket = socket = io.connect('http://107.170.78.222:8000/')
  window.game = game = new Game(socket)
