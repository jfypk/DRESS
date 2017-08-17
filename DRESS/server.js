var IP = "192.168.2.7" //get this from the MKR1000 code

var static = require('node-static');
var express = require('express');
var applet = express();
// the pem module creates an ssl certificate and key that let you serve
// content over https ( which is necessary for web rtc)
var pem = require('pem');
// secure http protocol
var https = require('https');
var requestify = require('requestify');
applet.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});
console.log('server running');
// applet.use(express.static('public'))
applet.use(express.static(__dirname + '/public'));
// create a route for the arduino
applet.get('/shirt', function(req, res){
	// console.log('hit ON route');
	requestify.get('http://'+ IP + '/SHIRT').then(function(response) {
		 console.log('sending shirt to arduino');
		var data = response.getBody();
	});
	res.send('shirt');
});
applet.get('/pants', function(req, res){
	// console.log('hit OFF route');
	// make a request to the arduino url
	requestify.get('http://'+ IP + '/PANTS').then(function(response) {
		 console.log('sending pants to arduino');
		var data = response.getBody();
	});
	res.send('pants');
});

applet.get('/socks', function(req, res){
	// console.log('hit OFF route');
	// make a request to the arduino url
	requestify.get('http://'+ IP + '/SOCKS').then(function(response) {
		 console.log('sending socks to arduino');
		var data = response.getBody();
	});
	res.send('socks');
});

applet.get('/shoes', function(req, res){
	// console.log('hit OFF route');
	// make a request to the arduino url
	requestify.get('http://'+ IP + '/SHOES').then(function(response) {
		 console.log('sending shoes to arduino');
		var data = response.getBody();
	});
	res.send('shoes');
});


var clients = 0;
// you're creating a static server because you're just serving a single static
// html file
var file = new(static.Server)();
// the 'createCertificate function takes two arguments:
// 1: the options for the certificate
// 2: a callback function that creates the keys, you create your server
// inside this callback function
pem.createCertificate({days:1, selfSigned:true}, function(err,keys){
	// create a server, passing in an object taht contains your newly
	// generated key and certificate, then server the html file and listen
	// on port 3000
	var app = https.createServer({
		key: keys.serviceKey,
		cert: keys.certificate,
	}
  ,applet)
  .listen(3003);

	const options = {
    key: keys.serviceKey,
    cert: keys.certificate
  };
 var app = https.createServer(options, applet).listen(3000);
	var io = require('socket.io')(app);
	io.on('connection', function(socket){

		console.log('client connected', socket.id);
		clients++;
		io.sockets.emit('broadcast',{ description: clients + ' clients connected!'});

		socket.on("shirt",function(){
			socket.broadcast.emit("shirt");
		});

		socket.on("pants",function(){
			socket.broadcast.emit("pants");
		});
		socket.on("socks",function(){
			socket.broadcast.emit("socks");
		});
    socket.on("shoes",function(){
      socket.broadcast.emit("shoes");
    });

		socket.on('disconnect', function () {
			clients--;
			io.sockets.emit('broadcast',{ description: clients + ' clients connected!'});
		});
	});

});
