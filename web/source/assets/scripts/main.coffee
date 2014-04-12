randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

socket = io.connect('http://localhost:8000');
socket.on 'update-game', (data) ->
  console.log(data)
  # $('h1').css({ top: data["player1"].y, left: data["player1"].x })
  

$('button.click-me').on 'click', -> 
  socket.emit('drill', {'playerID': randomInt(1, 4), 'drillPower': 10})

window.socket = socket
