import 'dart:convert';

import 'package:comms_flutter/constants.dart';
import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:comms_flutter/providers/chatroom_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late StateSetter builderSetState;

  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();

  bool _offer = false;

  RTCPeerConnection? _peerConnection;
  late MediaStream _localStream;

  bool isVideoRendered = false;
  bool isRemoteVideoRendered = false;

  @override
  void initState() {
    initRenderers();
    _getUserMedia();
    super.initState();
  }

  @override
  void dispose() {
    disposeRenderers();
    super.dispose();
  }

  // Methods to deal with WebRTC
  void initRenderers() async {
    await _localVideoRenderer.initialize();
  }

  Future<MediaStream> _getUserMedia() async {
    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localVideoRenderer.srcObject = stream;
    builderSetState(() {
      isVideoRendered = true;
    });
    return stream;
  }

  void disposeRenderers() async {
    await _localVideoRenderer.dispose();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };
    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(stunConfiguration, offerSdpConstraints);
    pc.addStream(_localStream);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(jsonEncode({
          "candidate": e.candidate,
          "sdpMid": e.sdpMid,
          "sdpMLineIndex": e.sdpMLineIndex,
        }));
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print("Add Stream: " + stream.id);
      _remoteVideoRenderer.srcObject = stream;
    };

    pc.onRemoveStream = (stream) {
      print("Remove Stream: " + stream.id);
    };

    _peerConnection = pc;
    return pc;
  }

  _createOffer() async {}

  // Main Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: AuthProvider.instance),
          ChangeNotifierProvider.value(value: ChatroomProvider.instance),
        ],
        child: _mainUI(),
      ),
    );
  }

  Widget _mainUI() {
    return StatefulBuilder(
        builder: (BuildContext innerContext, StateSetter innerSetState) {
      builderSetState = innerSetState;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Call'),
        ),
        body: Column(
          children: [
            isVideoRendered
                ? Expanded(
                    flex: 7,
                    child: RTCVideoView(_localVideoRenderer),
                  )
                : const CircularProgressIndicator(),
            isRemoteVideoRendered
                ? Expanded(
                    flex: 3,
                    child: RTCVideoView(_remoteVideoRenderer),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      );
    });
  }
}
