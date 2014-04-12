socket = io.connect('http://localhost:8000');
socket.on 'update-positions', (data) ->
  console.log(data)
  $('h1').css({ top: data["player1"].y, left: data["player1"].x })

window.socket = socket
