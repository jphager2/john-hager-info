var scheme   = "ws://";
var uri      = scheme + window.document.location.host + "/";
var ws       = new WebSocket(uri);

ws.onmessage = function(message) {
  var data = JSON.parse(message.data);
  $("#githubActivity").html("<p>" + data + "</p>");
};


