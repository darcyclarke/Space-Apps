randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

socket = io.connect('http://localhost:8000');
socket.on 'updateGame', (data) ->
  json = data
  console.log("===> ", json)
  # $('h1').css({ top: data["player1"].y, left: data["player1"].x })
  $('span.game').html("isOver: " + JSON.stringify(json["isOver"]))

  $('span.asteroid').html(JSON.stringify(json["asteroid"]))

  $('span.player1').html(JSON.stringify(json["players"]["player1"]))
  $('span.player2').html(JSON.stringify(json["players"]["player2"]))
  $('span.player3').html(JSON.stringify(json["players"]["player3"]))
  $('span.player4').html(JSON.stringify(json["players"]["player4"]))

$('button.click-me').on 'click', -> 
  socket.emit('drill', {
    'playerID': ("player" + randomInt(1, 4)), 
    'drillPower': randomInt(0, 1000)
  })

$('button.start').on 'click', -> 
  socket.emit('start')

window.socket = socket
