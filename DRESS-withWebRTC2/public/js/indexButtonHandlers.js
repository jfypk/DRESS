var startTime = 0;

function pants(){
  var myPants = document.getElementById("pants_");
  myPants.style.display = "block";
  $.get("/pants", function(res){
      console.log("pants LED");
  });
  window.setTimeout(function(){
    document.getElementById("pants_").style.display = 'none';
    socket.emit("pants");
  }, 3000);
}
function socks(){
  var mySocks = document.getElementById("socks_");
  mySocks.style.display = "block";

  $.get("/socks", function(res){
      console.log("socks LED");
  });
  window.setTimeout(function(){
    document.getElementById("socks_").style.display = 'none';
    socket.emit("socks");
  }, 3000);
}

function shirt(){

var myShirt = document.getElementById("shirt_");
  myShirt.style.display = "block";
  $.get("/shirt", function(res){
console.log("Shirt LED");
  });
  window.setTimeout(function(){
    document.getElementById('shirt_').style.display = 'none';
    socket.emit("shirt");
  }, 3000);
};

function shoes(){

var myShoes = document.getElementById("shoes_");
  myShoes.style.display = "block";
      $.get("/shoes", function(res){
          console.log("shoes LED");
      });
  window.setTimeout(function(){
    document.getElementById('shoes_').style.display = 'none';
    socket.emit("shoes");
  }, 3000);
};

function praise() {
  //load audio
  //play audio on patient's site 
  socket.emit('praise');
}

function caretakerCheckIn() {
    socket.emit('checkinOccurred');
    var answer = confirm("In your professional opinion, are you able to assist your patient without intervening in the room?\n\nPress OK for Yes, Cancel for No.");
    if (!answer) {
      //send message to patient in room that help is on the way
      socket.emit('checkinCancel');
    } else {
      socket.emit('checkinOK');
    }
}

setInterval(caretakerCheckIn, 180000); //call caretakercheckin every 3 minutes