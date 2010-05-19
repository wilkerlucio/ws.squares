require 'rubygems'
require 'sinatra'
require 'erb'

get '/' do
  erb :index
end

__END__

@@ index
<html>
	<head>
		<title>Websocket Timer</title>
	</head>
	<body>
	  <h1>Websockets Squares Experiment</h1>
	  <p>Use arrow keys to move your square! (you are the red one)</p>
		<script type="text/javascript" src="swfobject.js"></script>
		<script type="text/javascript" src="FABridge.js"></script>
		<script type="text/javascript" src="web_socket.js"></script>
		<script type="text/javascript" src="game.js"></script>
		<script type="text/javascript">
		
		WebSocket.__swfLocation = "WebSocketMain.swf";
		
		new Game();
		
		</script>
	</body>
</html>