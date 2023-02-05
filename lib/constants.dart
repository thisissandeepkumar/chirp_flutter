// Production
const String chatCoreHost = "https://chats.sandeepkumar.in";
final Map<String, dynamic> mediaConstraints = {
  'audio': true,
  'video': {
    'facingMode': 'user',
  }
};
Map<String, dynamic> stunConfiguration = {
  "iceServers": [
    {"url": "stun:stun.l.google.com:19302"},
  ]
};
