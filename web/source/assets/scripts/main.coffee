
socket = io.connect('http://localhost:8000');
socket.on 'update-positions', (data) ->
  console.log(data)
  $('h1').css({ top: data.y, left: data.x })