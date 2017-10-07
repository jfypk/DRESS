var socket = io();

//CHANGE FILE TO CORRECT AUDIO
var shirtInstructionFile1 = new Audio("../assets/shirt/shirt2.mp3");
var shirtInstructionFile2 = new Audio("../assets/shirt/shirt3.mp3");
var shirtInstructionFile3 = new Audio("../assets/shirt/shirt4.mp3");
var shirtInstructionFile4 = new Audio("../assets/shirt/shirt5.mp3");
var shirtInstructionFile5 = new Audio("../assets/shirt/shirt6.mp3");
var shirtInstructionFile6 = new Audio("../assets/shirt/shirt7.mp3");
var pantsInstructionFile1 = new Audio("../assets/pants/pants1.mp3");
var pantsInstructionFile2 = new Audio("../assets/pants/pants2.mp3");
var pantsInstructionFile3 = new Audio("../assets/pants/pants3.mp3");
var pantsInstructionFile4 = new Audio("../assets/pants/pants4.mp3");
var pantsInstructionFile5 = new Audio("../assets/pants/pants5.mp3");
var pantsInstructionFile6 = new Audio("../assets/pants/pants6.mp3");
var socksInstructionFile1 = new Audio("audio/test3.mp3");
var socksInstructionFile2 = new Audio("audio/test3.mp3");
var socksInstructionFile3 = new Audio("audio/test3.mp3");
var socksInstructionFile4 = new Audio("audio/test3.mp3");
var socksInstructionFile5 = new Audio("audio/test3.mp3");
var socksInstructionFile6 = new Audio("audio/test3.mp3");
var shoesInstructionFile1 = new Audio("audio/woohoo.mp3");
var shoesInstructionFile2 = new Audio("audio/woohoo.mp3");
var shoesInstructionFile3 = new Audio("audio/woohoo.mp3");
var shoesInstructionFile4 = new Audio("audio/woohoo.mp3");
var shoesInstructionFile5 = new Audio("audio/woohoo.mp3");
var shoesInstructionFile6 = new Audio("audio/woohoo.mp3");

var checkInCancelAudio = new Audio("audio/woohoo.mp3");

socket.on('broadcast', function(data) {
    console.log(data.description);
});

socket.on("pants", pants);
socket.on("pants1", pantsInstructions1);
socket.on("pants2", pantsInstructions2);
socket.on("pants3", pantsInstructions3);
socket.on("pants4", pantsInstructions4);
socket.on("pants5", pantsInstructions5);
socket.on("pants6", pantsInstructions6);
socket.on("shoes", shoes);
socket.on("shoes1", shoesInstructions1);
socket.on("shoes2", shoesInstructions2);
socket.on("shoes3", shoesInstructions3);
socket.on("shoes4", shoesInstructions4);
socket.on("shoes5", shoesInstructions5);
socket.on("shoes6", shoesInstructions6);
socket.on("socks", socks);
socket.on("socks1", socksInstructions1);
socket.on("socks2", socksInstructions2);
socket.on("socks3", socksInstructions3);
socket.on("socks4", socksInstructions4);
socket.on("socks5", socksInstructions5);
socket.on("socks6", socksInstructions6);
socket.on("shirt", shirt);
socket.on("shirt1", shirtInstructions1);
socket.on("shirt2", shirtInstructions2);
socket.on("shirt3", shirtInstructions3);
socket.on("shirt4", shirtInstructions4);
socket.on("shirt5", shirtInstructions5);
socket.on("shirt6", shirtInstructions6);

socket.on("checkinCancel", caretakerComing);

function caretakerComing() {
    checkInCancelAudio.play();
}

function pants() {
    console.log('pants button pressed');
};

function pantsInstructions1() {
    pantsInstructionFile1.play();
};

function pantsInstructions2() {
    pantsInstructionFile2.play();
};

function pantsInstructions3() {
    pantsInstructionFile3.play();
};

function pantsInstructions4() {
    pantsInstructionFile4.play();
};

function pantsInstructions5() {
    pantsInstructionFile5.play();
};

function pantsInstructions6() {
    pantsInstructionFile6.play();
};

function shoes() {
    console.log("shoes button pressed");
};

function shoesInstructions1() {
    shoesInstructionFile1.play();
};

function shoesInstructions2() {
    shoesInstructionFile2.play();
};

function shoesInstructions3() {
    shoesInstructionFile3.play();
};

function shoesInstructions4() {
    shoesInstructionFile4.play();
};

function shoesInstructions5() {
    shoesInstructionFile5.play();
};

function shoesInstructions6() {
    shoesInstructionFile6.play();
};

function socks() {
    console.log("socks button pressed");
};

function socksInstructions1() {
    socksInstructionFile1.play();
};

function socksInstructions2() {
    socksInstructionFile2.play();
};

function socksInstructions3() {
    socksInstructionFile3.play();
};

function socksInstructions4() {
    socksInstructionFile4.play();
};

function socksInstructions5() {
    socksInstructionFile5.play();
};

function socksInstructions6() {
    socksInstructionFile6.play();
};

function shirt() {
    console.log("shirt button pressed");
};

function shirtInstructions1() {
    shirtInstructionFile1.play();
};

function shirtInstructions2() {
    shirtInstructionFile2.play();
};

function shirtInstructions3() {
    shirtInstructionFile3.play();
};

function shirtInstructions4() {
    shirtInstructionFile4.play();
};

function shirtInstructions5() {
    shirtInstructionFile5.play();
};

function shirtInstructions6() {
    shirtInstructionFile6.play();
};