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