#!/usr/bin/ruby

require 'rubygems'
require 'em-websocket'

def random_id(length)
  chars = 'qwertyuiopasdfghjklzxcvbnm1234567890'
  id = ''

  while id.length < length
    id << chars[rand(chars.length),1]
  end
  
  id
end

class Player
  attr_reader :socket, :id, :alive
  attr_accessor :x, :y
  
  def initialize(socket)
    @socket = socket
    @x = rand(100)
    @y = rand(100)
    @id = random_id(20)
    @alive = true
  end
  
  def update_position(x, y)
    @x = x
    @y = y
  end
  
  def kill
    @alive = false
  end
  
  def to_json
    "{id: '#{@id}', x: #{@x}, y: #{@y}}"
  end
end

players = []

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
  player = Player.new(ws)
  
  ws.onopen do
    puts "Connected player #{player.id}"
    ws.send("{yourid: '#{player.id}'}")
    
    players.each do |p|
      p.socket.send player.to_json
      ws.send p.to_json
    end
    
    ws.send player.to_json
    players << player
  end
  
  ws.onmessage do |data|
    x, y = data.split(',')
    player.update_position(x, y)
    
    players.each do |p|
      p.socket.send player.to_json unless p.id == player.id
    end
  end
  
  ws.onclose do
    player.kill
    
    players.reject! { |p| !p.alive }
    players.each do |p|
      p.socket.send "{removePlayer: '#{player.id}'}"
    end
    
    puts "Removed player #{player.id}"
    player = nil
  end
end