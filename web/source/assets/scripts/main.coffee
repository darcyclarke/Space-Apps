
socket = io.connect('http://localhost:8000');
socket.on 'news', (data) ->
  console.log(data)
  socket.emit('my other event', my: 'data')
