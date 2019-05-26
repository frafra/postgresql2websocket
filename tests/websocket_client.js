const WebSocket = require('ws');
ws = new WebSocket("ws://localhost:8080/postgresql2websocket");
ws.onmessage = function (message) {
  console.log(message.data);
}
