
var muted = true;
var talkStatus;
var webrtc = new SimpleWebRTC({
	// localVideoEl: 'localVideo',
	remoteVideosEl: 'remotesVideos',
	autoRequestMedia: true,
    media: {
    audio: true,
    video: false
}
});

webrtc.on('connectionReady', function(sessionId) {
    //initialization code here    
});

 webrtc.on('readyToCall', function () {
	console.log("reached index ready to call");
    webrtc.joinRoom('cam1');
    webrtc.mute();
    muted = true;
 });

webrtc.on('createdPeer', function (peer) {
    console.log('createdPeer', peer);

});

function toggleTalk() {   
    console.log('talk button pressed');
    var talkButton = document.getElementById('TALKbutton');
    if(muted) {
        console.log('caretaker unmuted');
        webrtc.unmute();
        talkStatus=document.getElementById('talkStatus');
        talkStatus.innerHTML = "Caretaker Unmuted"
        talkButton.value = "Mute";
        socket.emit("unmuted");
    } else {
        console.log('caretaker muted');
        webrtc.mute();
        talkStatus.innerHTML = "Caretaker Muted"
        talkButton.value = "Unmute";
        var summary = prompt("To help improve this prototype, please summarize the conversation you had with your patient just now");
        socket.emit("muted", { data: summary });
    }
    muted = !muted;
}

webrtc.on('videoAdded', function (video, peer) {
    console.log('video added', peer);
    // console.log("dog");
    var remotes = document.getElementById('remotes');
    if (remotes) {
        var container = document.createElement('div');
        container.className = 'videoContainer';
        container.id = 'container_' + webrtc.getDomId(peer);
        container.appendChild(video);

        // suppress contextmenu
        video.oncontextmenu = function () { return false; };

        remotes.appendChild(container);
    }
    // show the ice connection state
    if (peer && peer.pc) {
        var connstate = document.createElement('div');
        connstate.className = 'connectionstate';
        container.appendChild(connstate);
        peer.pc.on('iceConnectionStateChange', function (event) {
            switch (peer.pc.iceConnectionState) {
            case 'checking':
                connstate.innerText = 'Connecting to peer...';
                break;
            case 'connected':
            case 'completed': // on caller side
                connstate.innerText = 'Connection established.';
                break;
            case 'disconnected':
                connstate.innerText = 'Disconnected.';
                break;
            case 'failed':
                break;
            case 'closed':
                connstate.innerText = 'Connection closed.';
                break;
            }
        });
    }
});

webrtc.on('videoRemoved', function (video, peer) {
    console.log('video removed ', peer);
    var remotes = document.getElementById('remotes');
    var el = document.getElementById(peer ? 'container_' + webrtc.getDomId(peer) : 'localScreenContainer');
    if (remotes && el) {
        remotes.removeChild(el);
    }
});

webrtc.on('mute', function (data) { // show muted symbol
    webrtc.getPeers(data.id).forEach(function (peer) {
        if (data.name == 'audio') {
            $('#videocontainer_' + webrtc.getDomId(peer) + ' .muted').show();
        } else if (data.name == 'video') {
            $('#videocontainer_' + webrtc.getDomId(peer) + ' .paused').show();
            $('#videocontainer_' + webrtc.getDomId(peer) + ' video').hide();
        }
    });
});
webrtc.on('unmute', function (data) { // hide muted symbol
    webrtc.getPeers(data.id).forEach(function (peer) {
        if (data.name == 'audio') {
            $('#videocontainer_' + webrtc.getDomId(peer) + ' .muted').hide();
        } else if (data.name == 'video') {
            $('#videocontainer_' + webrtc.getDomId(peer) + ' video').show();
            $('#videocontainer_' + webrtc.getDomId(peer) + ' .paused').hide();
        }
    });
});

