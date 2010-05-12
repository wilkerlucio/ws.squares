(function(){
  var Player, players, randomId, sys, ws;
  //!/usr/local/bin/coffee
  sys = require("sys");
  ws = require("./ws");
  randomId = function randomId(length) {
    var chars, id;
    chars = 'qwertyuiopasdfghjklzxcvbnm1234567890';
    id = '';
    while (id.length < length) {
      id += chars.charAt(Math.round(Math.random() * (chars.length - 1)));
    }
    return id;
  };
  Player = function Player(socket) {
    this.socket = socket;
    this.x = Math.round(Math.random() * 100);
    this.y = Math.round(Math.random() * 100);
    this.id = randomId(20);
    this.alive = true;
    return this;
  };
  Player.prototype.updatePosition = function updatePosition(x, y) {
    this.x = x;
    this.y = y;
    return this.y;
  };
  Player.prototype.kill = function kill() {
    this.alive = false;
    return this.alive;
  };
  Player.prototype.toData = function toData() {
    return "{id: '" + (this.id) + "', x: " + (this.x) + ", y: " + (this.y) + "}";
  };
  players = [];
  ws.createServer(function(websocket) {
    var player;
    player = new Player(websocket);
    websocket.addListener("connect", function(resource) {
      sys.debug(("Connected player " + (player.id)));
      websocket.write(("{yourid: '" + (player.id) + "'}"));
      players.forEach(function(p) {
        p.socket.write(player.toData());
        return websocket.write(p.toData());
      });
      websocket.write(player.toData());
      return players.push(player);
    });
    websocket.addListener("data", function(data) {
      var pos;
      pos = data.split(',');
      player.x = pos[0];
      player.y = pos[1];
      return players.forEach(function(p) {
        if (p.id !== player.id) {
          return p.socket.write(player.toData());
        }
      });
    });
    return websocket.addListener("close", function() {
      var players_buffer;
      player.kill();
      players_buffer = [];
      players.forEach(function(p) {
        if (p.alive) {
          players_buffer.push(p);
          return p.socket.write(("{removePlayer: '" + (player.id) + "'}"));
        }
      });
      players = players_buffer;
      delete player;
      return sys.debug(("Killed player " + (player.id)));
    });
  }).listen(8080);
})();
