//This is the Arduino IP. Get this from the MKR1000 code
var IP = "192.168.2.7" 

//set these to the fiduciary numbers corresponding to the clothes
var shirtFid = 31;
var pantsFid = 1;
var socksFid = 2;
var shoesFid = 29;

var static = require('node-static');
var express = require('express');
var applet = express();
// the pem module creates an ssl certificate and key that let you serve
// content over https ( which is necessary for web rtc)
var pem = require('pem');
// secure http protocol
var https = require('https');
var requestify = require('requestify');
var Tuio = require('tuio-nw');
var tuioClient = new Tuio.Client({
    host: '127.0.0.1',
    port: '3333'
});

/*
 * Define helper methods
 */
applet.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

console.log('server running');

var changeShirtLED = function() {
        requestify.get('http://'+ IP + '/SHIRT').then(function(response) {
        console.log('sending shirt to arduino');
		var data = response.getBody();
	});
    }, 
    
    changePantsLED = function() {
        requestify.get('http://'+ IP + '/PANTS').then(function(response) {
        console.log('sending pants to arduino');
		var data = response.getBody();
	});
    }, 
    
    changeSocksLED = function() {
        requestify.get('http://'+ IP + '/SOCKS').then(function(response) {
        console.log('sending socks to arduino');
		var data = response.getBody();
	});
    }, 
    
    changeShoesLED = function() {
        requestify.get('http://'+ IP + '/SHOES').then(function(response) {
        console.log('sending shoes to arduino');
		var data = response.getBody();
	});
    };

// applet.use(express.static('public'))
applet.use(express.static(__dirname + '/public'));

// create a route for the arduino
applet.get('/shirt', function(req, res){
	// console.log('hit ON route');
	changeShirtLED();
	res.send('shirt');
});
applet.get('/pants', function(req, res){
	// console.log('hit OFF route');
	// make a request to the arduino url
	changePantsLED();
	res.send('pants');
});
applet.get('/socks', function(req, res){
	// console.log('hit OFF route');
	// make a request to the arduino url
	changeSocksLED();
	res.send('socks');
});
applet.get('/shoes', function(req, res){
	// console.log('hit OFF route');
	// make a request to the arduino url
	changeShoesLED();
	res.send('shoes');
});

//TUIO helper methods
var onAddTuioCursor = function (addCursor) {
    //console.log("adding cursor");
    //console.log(addCursor);
},
 
onUpdateTuioCursor = function (updateCursor) {
    //console.log("updating cursor");
    //console.log(updateCursor);
},
 
onRemoveTuioCursor = function (removeCursor) {
    //console.log("removing cursor");
    //console.log(removeCursor);
},
 
onAddTuioObject = function (addObject) {
    console.log("adding object " + addObject.symbolId);
    if(addObject.symbolId === shirtFid) {
        console.log("shirt added");  
        changeShirtLED();
    } else if (addObject.symbolId === pantsFid) {
        console.log("pants added");
        changePantsLED();
    } else if (addObject.symbolId === socksFid) {
        console.log("socks added");
        changeSocksLED();
    } else if (addObject.symbolId === shoesFid) {
        console.log("shoes added");
        changeShoesLED();
    }
},
 
onUpdateTuioObject = function (updateObject) {
    //console.log("updating object");
    //console.log(updateObject);
},
 
onRemoveTuioObject = function (removeObject) {
    console.log("removing object " + removeObject.symbolId);
    if(removeObject.symbolId === shirtFid) {
        shirtDetected = false;
        console.log("shirt removed");
    } else if (removeObject.symbolId === pantsFid) {
        pantsDetected = false;
        console.log("pants removed");
    } else if (removeObject.symbolId === socksFid) {
        socksDetected = false;
        console.log("socks removed");
    } else if (removeObject.symbolId === shoesFid) {
        shoesDetected = false;
        console.log("shoes removed");
    }
},
 
onRefresh = function (time) {
    //console.log("updating time");
    //console.log(time);
};

tuioClient.on('addTuioCursor', onAddTuioCursor);
tuioClient.on('updateTuioCursor', onUpdateTuioCursor);
tuioClient.on('removeTuioCursor', onRemoveTuioCursor);
tuioClient.on('addTuioObject', onAddTuioObject);
tuioClient.on('updateTuioObject', onUpdateTuioObject);
tuioClient.on('removeTuioObject', onRemoveTuioObject);
tuioClient.on('refresh', onRefresh);

tuioClient.listen();

/*
 * Call the server
 */
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
	}, applet).listen(3003);

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
            socket.broadcast.emit("shirt");      //this is the text that gets shown on /patient 
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
