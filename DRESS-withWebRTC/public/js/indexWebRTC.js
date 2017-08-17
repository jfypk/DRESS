
var webrtc = new SimpleWebRTC({
	// localVideoEl: 'localVideo',
	remoteVideosEl: 'remotesVideos',
	autoRequestMedia: true,
});

webrtc.on('connectionReady', function(sessionId) {
    webrtc.createRoom('DRESS-cam1', function() {
    console.log('cam1 started');
    });

    //makes the caretaker invisible.
    webrtc.mute();
    webrtc.pauseVideo();
});

 webrtc.on('readyToCall', function () {
	webrtc.joinRoom('cam1 started');
 });

webrtc.on('createdPeer', function (peer) {
    console.log('createdPeer', peer);

});



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
});

webrtc.on('videoRemoved', function (video, peer) {
    console.log('video removed ', peer);
    var remotes = document.getElementById('remotes');
    var el = document.getElementById(peer ? 'container_' + webrtc.getDomId(peer) : 'localScreenContainer');
    if (remotes && el) {
        remotes.removeChild(el);
    }
});

