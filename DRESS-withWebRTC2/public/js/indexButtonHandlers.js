var startTime = 0;
  var pantsInstructionsList;
  var shirtInstructionsList;
  var shoesInstructionsList;
  var socksInstructionsList;


function pants(){
  pantsInstructionsList = document.getElementById("pantsbuttons");
  shirtInstructionsList = document.getElementById("shirtbuttons");
  shoesInstructionsList = document.getElementById("shoesbuttons");
  socksInstructionsList = document.getElementById("socksbuttons");
  shirtInstructionsList.style.display = "none";
  shoesInstructionsList.style.display = "none";
  socksInstructionsList.style.display = "none";
  pantsInstructionsList.style.display = "block";

  $.get("/pants", function(res){
      console.log("pants LED");
  });
}

function socks(){
  pantsInstructionsList = document.getElementById("pantsbuttons");
  shirtInstructionsList = document.getElementById("shirtbuttons");
  shoesInstructionsList = document.getElementById("shoesbuttons");
  socksInstructionsList = document.getElementById("socksbuttons");
  shirtInstructionsList.style.display = "none";
  shoesInstructionsList.style.display = "none";
  socksInstructionsList.style.display = "block";
  pantsInstructionsList.style.display = "none";

  $.get("/socks", function(res){
      console.log("socks LED");
  });
}

function shirt() {
  pantsInstructionsList = document.getElementById("pantsbuttons");
  shirtInstructionsList = document.getElementById("shirtbuttons");
  shoesInstructionsList = document.getElementById("shoesbuttons");
  socksInstructionsList = document.getElementById("socksbuttons");
  shirtInstructionsList.style.display = "block";
  shoesInstructionsList.style.display = "none";
  socksInstructionsList.style.display = "none";
  pantsInstructionsList.style.display = "none";

  $.get("/shirt", function(res){
    console.log("Shirt LED");
  });
};

function shoes() {
  pantsInstructionsList = document.getElementById("pantsbuttons");
  shirtInstructionsList = document.getElementById("shirtbuttons");
  shoesInstructionsList = document.getElementById("shoesbuttons");
  socksInstructionsList = document.getElementById("socksbuttons");
  shirtInstructionsList.style.display = "none";
  shoesInstructionsList.style.display = "block";
  socksInstructionsList.style.display = "none";
  pantsInstructionsList.style.display = "none";

  $.get("/shoes", function(res){
      console.log("shoes LED");
  });
};

function sendInstruction(cloth, number){
  var socketPhrase = cloth + number;
  window.setTimeout(function(){
    socket.emit(socketPhrase);
  }, 3000); 
}

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

function getVideoSources() {
  var videoDevices = [];
  socket.on("videoSent", function(data) {
    console.log(data);
  });
}

setInterval(caretakerCheckIn, 180000); //call caretakercheckin every 3 minutes