#!/usr/local/bin/coffee

sys: require("sys")
ws: require("./ws")

randomId: (length) ->
  chars: 'qwertyuiopasdfghjklzxcvbnm1234567890'
  id: ''
  
  while id.length < length
    id += chars.charAt(Math.round(Math.random() * (chars.length - 1)))
  
  id

class Player
  constructor: (socket) ->
    @socket: socket
    @x: Math.round(Math.random() * 100)
    @y: Math.round(Math.random() * 100)
    @id: randomId(20)
    @alive: true
  
  updatePosition: (x, y) ->
    @x: x
    @y: y
  
  kill: ->
    @alive: false
  
  toData: ->
    "{id: '${@id}', x: ${@x}, y: ${@y}}"

players: []

ws.createServer((websocket) ->
  player: new Player(websocket)
  
  websocket.addListener "connect", (resource) ->
    sys.debug "Connected player ${player.id}"
    websocket.write("{yourid: '${player.id}'}")
    
    players.forEach (p) ->
      p.socket.write(player.toData())
      websocket.write(p.toData())
    
    websocket.write(player.toData())
    players.push(player)
  
  websocket.addListener "data", (data) ->
    pos: data.split(',')
    player.x: pos[0]
    player.y: pos[1]
    
    players.forEach (p) ->
      p.socket.write(player.toData()) if p.id != player.id
  
  websocket.addListener "close", ->
    player.kill()
    players_buffer: []
    
    players.forEach (p) ->
      if p.alive
        players_buffer.push(p)
        p.socket.write("{removePlayer: '${player.id}'}")
    
    players: players_buffer
    delete player
    sys.debug("Killed player ${player.id}")
).listen(8080)
