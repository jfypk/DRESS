var socket = io();

  socket.on('broadcast',function(data){
      console.log(data.description);
  });

  socket.on("pants",function(){
    document.getElementById('pants_').style.display = 'block';
    window.setTimeout(function(){
      document.getElementById('pants_').style.display = 'none';
      //socket.emit("shirt");
    }, 3000);
  })

  socket.on("socks",function(){
    document.getElementById('socks_').style.display = 'block';
    window.setTimeout(function(){
      document.getElementById('socks_').style.display = 'none';
      //socket.emit("shirt");
    }, 3000);
  })

  socket.on("shoes",function(){
    document.getElementById('shoes_').style.display = 'block';
    window.setTimeout(function(){
      document.getElementById('shoes_').style.display = 'none';
      //socket.emit("shirt");
    }, 3000);
  })

  socket.on("shirt",function(){
    $("#SHIRT").click(function(){
        $.get("/shirt", function(res){

        });
        console.log("still happened");
    });
    document.getElementById('shirt_').style.display = 'block';
    window.setTimeout(function(){
      document.getElementById('shirt_').style.display = 'none';
      //socket.emit("shirt");
    }, 3000);
  })