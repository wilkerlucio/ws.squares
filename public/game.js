Game = function() {
  this.socket = new WebSocket("ws://localhost:8080");
  this.appendEvents();
  this.appendGuiEvents();
  this.id = null;
  this.x = null;
  this.y = null;
  this.waiting_position = true;
};

Game.prototype = {
  appendEvents: function() {
    var self = this;
    
  	this.socket.onopen = function(event) {
  	};

  	this.socket.onmessage = function(event) {
  		var data = eval('(' + event.data + ')');
  		
  		if (data.yourid) {
  		  self.id = data.yourid;
  		} else if(data.removePlayer) {
  		  var element = self.getPlayer(data.removePlayer);
  		  document.body.removeChild(element);
  		} else {
  		  if (data.id != self.id || self.waiting_position) {
      		var element = self.getPlayer(data.id);
          element.style.left = data.x + 'px';
          element.style.top = data.y + 'px';
          
    		  if (data.id == self.id) {
    		    self.x = data.x;
    		    self.y = data.y;
    		    self.waiting_position = false;
  		    }
  		  }
  		}
  	};

  	this.socket.onclose = function(event) {
  	};
  },
  
  appendGuiEvents: function() {
    var self = this;
    
    window.onkeydown = window.onkeypress = function(evt) {
      var k = evt.keyCode;
      
      if (k > 36 && k < 41) {
        if (k == 37) self.x -= 2;
        if (k == 38) self.y -= 2;
        if (k == 39) self.x += 2;
        if (k == 40) self.y += 2;
        
        self.socket.send(self.x + ',' + self.y);
        
        var el = self.getPlayer(self.id);
        el.style.left = self.x + 'px';
        el.style.top = self.y + 'px';
      }
    }
  },
  
  getPlayer: function(id) {
    var element = document.getElementById("player-" + id);
    
    if (!element) {
      element = document.createElement("div");
      element.id = "player-" + id;
      element.style.position = 'absolute';
      element.style.width = '10px';
      element.style.height = '10px';
      element.style.backgroundColor = (id == this.id ? '#f00' : '#000');
      
      document.body.appendChild(element);
    }
    
    return element;
  }
};