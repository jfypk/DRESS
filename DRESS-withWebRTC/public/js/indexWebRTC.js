
var webrtc = new SimpleWebRTC({
	// localVideoEl: 'localVideo',
	remoteVideosEl: 'remotesVideos',
	autoRequestMedia: true,
});

webrtc.on('connectionReady', function(sessionId) {
    //initialization code here    
});

 webrtc.on('readyToCall', function () {
	console.log("reached index ready to call");
    webrtc.joinRoom('cam1');
    webrtc.mute();
    // webrtc.pauseVideo();
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

