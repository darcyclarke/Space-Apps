
express = require('express')
app = express()
http = require('http')
server = http.createServer(app)
io = require('socket.io').listen(server)

app.use('/assets', express.static(__dirname + '/assets'))

app.get '/', (req, res) ->
  res.sendfile(__dirname + '/index.html')

io.sockets.on 'connection', (socket) ->
  socket.emit('news', { hello: 'world'})
  socket.on 'my something', (data) ->
    console.log(data)

http.createServer(app).listen(8000)
