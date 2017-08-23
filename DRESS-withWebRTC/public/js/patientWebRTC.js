var webrtc = new SimpleWebRTC({
  // requires our own url for signaling server
	// remoteVideosEl: 'remotesVideos',
	autoRequestMedia: true,
  receiveMedia: {
    offerToReceiveAudio: 1,
    offerToReceiveVideo: 0
  },
  media: {
    audio: true,
    video: true
}
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
    var remotes = document.getElementById('patientremotes1');
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
    var remotes = document.getElementById('patientremotes1');
    var el = document.getElementById(peer ? 'container_' + webrtc.getDomId(peer) : 'localScreenContainer');
    if (remotes && el) {
        remotes.removeChild(el);
    }
});

var audioDevices = [],
    videoDevices = [];
    navigator.mediaDevices.enumerateDevices().then(function (devices) {
      for (var i = 0; i !== devices.length; ++i) {
          var device = devices[i];
          if (device.kind === 'audioinput') {
              device.label = device.label || 'microphone ' + (audioDevices.length + 1);
              audioDevices.push(device);
              console.log(audioDevices);
          } else if (device.kind === 'videoinput') {
              device.label = device.label || 'camera ' + (videoDevices.length + 1);
              videoDevices.push(device);
              console.log(videoDevices);
          }
      }
    });
