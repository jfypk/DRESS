var socket = io();

//CHANGE FILE TO CORRECT AUDIO
var shirtInstructions = new Audio("audio/test.mp3");
var pantsInstructions = new Audio("audio/test2.mp3");
var socksInstructions = new Audio("audio/test3.mp3");
var shoesInstructions = new Audio("audio/woohoo.mp3");

socket.on('broadcast',function(data){

      console.log(data.description);
  });

socket.on("pants", pants);
socket.on("shoes", shoes);
socket.on("socks", socks);
socket.on("shirt", shirt);

function pants() {
    pantsInstructions.play();
    var vid = document.getElementById("myVideo");
      vid.play();
    document.getElementById('pants_').style.display = 'block';
    document.getElementById("myVideo").style.display = 'block';
    console.log("hello")
    window.setTimeout(function(){
      document.getElementById('pants_').style.display = 'none';

    }, 3000);
      window.setTimeout(function(){
        document.getElementById("myVideo").style.display = 'none';
      }, 7000);
};

function shoes() {
    shoesInstructions.play();
    
    document.getElementById('shoes_').style.display = 'block';
    window.setTimeout(function(){
      document.getElementById('shoes_').style.display = 'none';
      //socket.emit("shirt");
    }, 3000);
};

function socks() {
    socksInstructions.play();
    
    document.getElementById('socks_').style.display = 'block';
    window.setTimeout(function(){
      document.getElementById('socks_').style.display = 'none';
    }, 3000);
};

function shirt(){
    shirtInstructions.play();
    
    document.getElementById('shirt_').style.display = 'block';
    window.setTimeout(function(){
      document.getElementById('shirt_').style.display = 'none';
      //socket.emit("shirt");
    }, 3000);
  };