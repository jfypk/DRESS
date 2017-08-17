var webrtc = new SimpleWebRTC({
	// remoteVideosEl: 'remotesVideos',
	autoRequestMedia: true,
  media: {
    video: {
      mandatory: {
        maxWidth: 700,
        maxHeight: 480
      }
    }
  }
});


 webrtc.on('readyToCall', function () {
	webrtc.joinRoom('DRESS-cam1');
 });

webrtc.on('createdPeer', function (peer) {
    console.log('createdPeer', peer);

});