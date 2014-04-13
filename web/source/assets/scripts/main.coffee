
# ---------------------------------------------------
# Game Class

class Game

    constructor: (socket) ->

      console.log('Game Started')

      @socket         = socket
      @won            = false
      @time           = 90
      @currentScreen  = 0
      @screenDelay    = 2000
      @$game          = $('.game')
      @$countdown     = $('.countdown')
      @$screens       = $('.screen')
      @asteroid       = new Asteroid()
      @players        = []

      @players.push(new Player('red'))
      @players.push(new Player('blue'))
      @players.push(new Player('green'))
      @players.push(new Player('yellow'))

      @socket.on 'scarceMineralCollected', (data) =>
        player = @getPlayer(data.playerID)
        console.log('Found Rare Mineral!', player)
        @players[player].notification('scarce', data)

      @socket.on 'commonMineralCollected', (data) =>
        player = @getPlayer(data.playerID)
        console.log('Found Common Mineral!', player)
        @players[player].notification('common', data)

      @socket.on 'updateGame', (data) =>
        @updateGame(data)

      @nextScreen()

    updateGame: (data) ->
      console.log('Game Update!', data)
      if(data.isOver)
        @won = data.didWin
        if(@won)
          @$screens.css( opacity: 0 ).filter('.skyline').css( opacity: 1 )
        else
          @$screens.css( opacity: 0 ).filter('.end').css( opacity: 1 )
        console.log('Game Over!')

    getPlayer: (id) ->
      if(id == 'player1')
        return 0
      if(id == 'player2')
        return 1
      if(id == 'player3')
        return 2
      if(id == 'player4')
        return 3

    startCountdown: () ->
      console.log('Countdown Started')
      @socket.emit('start')
      increment = () =>
        @time = @time - 1
        @$countdown.text(@time)

        # Make universe work...
        if(@time <= 10)
          $('.asteroids .asteroid').css( transform: 'scale(0.1)' )
          $('.asteroids').css( top: '+=375px' )
          $('.earth img').css( width: 'scale(4)')

        if(@time <= 20)
          $('.asteroids .asteroid').css( transform: 'scale(0.25)' )
          $('.asteroids').css( top: '+=300px' )
          $('.earth img').css( width: 'scale(3)')

        if(@time <= 30)
          $('.asteroids .asteroid').css( transform: 'scale(0.5)' )
          $('.asteroids').css( top: '+=225px' )
          $('.earth img').css( width: 'scale(2)')

        if(@time <= 50)
          $('.asteroids .asteroid').css( transform: 'scale(0.75)' )
          $('.asteroids').css( top: '+=150px' )
          $('.earth img').css( transform: 'scale(1.5)')

        if(@time <= 80)
          $('.asteroids').css( transform: 'scale(0.9)' )
          $('.asteroids .asteroid').css( top: '+=75px' )
          $('.earth img').css( transform: 'scale(1.25)')

        if(@time <= 0)
          console.log('time up!')
          clearInterval(@counter)
          @socket.emit('timeUp')
      @counter = setInterval(increment, 1000)

    nextScreen: () ->
      x = @currentScreen
      @screenDelay = @$screens.eq(x).data('delay') or @screenDelay
      increment = () =>
        @currentScreen = @currentScreen + 1
        @nextScreen()
      @$screens.css( opacity: 0 ).eq(x).css( opacity: 1 )
      return if((x + 1)  >= @$screens.length)
      if(@$screens.eq(x).hasClass('game'))
        @startCountdown()
      else
        setTimeout(increment, @screenDelay)

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

    notification: (type, data) ->

      # Add minerals to bars!
      @$minerals_overall.css( width: '+=1%' )
      if(type == 'common')
        @$minerals_common.css( width: '+=1%' )
      if(type == 'scarce')
        @$minerals_scarce.css( width: '+=1%' )

      name          = data.name or '...'
      element       = data.element or '...'
      amount        = data.amount or 0
      $template     = $('<div class="notification cf rare"><p class="text"><strong>+' + amount+ '</strong> ' + name + ' Gained - ' + element + '</p></div>')
      $template.appendTo(@player_notifications).show().delay(500).remove()

    addMineral: (data) ->
      console.log(data)

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
  window.socket = socket = io.connect('http://192.168.106.50:8000/')
  window.game = game = new Game(socket)
