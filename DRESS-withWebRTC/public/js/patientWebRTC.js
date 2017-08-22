var webrtc = new SimpleWebRTC({
  // requires our own url for signaling server
	// remoteVideosEl: 'remotesVideos',
	autoRequestMedia: true,
  receiveMedia: {
    offerToReceiveAudio: 1,
    offerToReceiveVideo: 0
  }
  // media: {
  //   video: false,
  //   audio: true
  //   // video: {
  //   //   mandatory: {
  //   //     maxWidth: 700,
  //   //     maxHeight: 480
  //   //   }
  //   // }
  // }
});


 webrtc.on('readyToCall', function () {
  webrtc.joinRoom('cam1');
 });

webrtc.on('createdPeer', function (peer) {
    console.log('createdPeer', peer);

});

webrtc.on('videoAdded', function (video, peer) {
    console.log('video added', peer);
    // console.log("dog");
    var remotes = document.getElementById('patientremotes');
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
    var remotes = document.getElementById('patientremotes');
    var el = document.getElementById(peer ? 'container_' + webrtc.getDomId(peer) : 'localScreenContainer');
    if (remotes && el) {
        remotes.removeChild(el);
    }
});