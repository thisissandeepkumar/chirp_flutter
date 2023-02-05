// Production
const String chatCoreHost = "https://chats.sandeepkumar.in";
final Map<String, dynamic> mediaConstraints = {
  'audio': true,
  'video': {
    'facingMode': 'user',
  }
};
Map<String, dynamic> stunConfiguration = {
  // "sdpSemantics": "unified-plan",
  "iceServers": [
    // {"url": "stun4.l.google.com:19302"},
    {"url": "stun2.l.google.com:19302"},
    {"url": "stun3.l.google.com:19302"},
  ]
};
