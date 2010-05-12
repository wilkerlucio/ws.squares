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