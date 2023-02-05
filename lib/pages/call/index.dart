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

  void _getUserMedia() async {
    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localVideoRenderer.srcObject = stream;
    builderSetState(() {
      isVideoRendered = true;
    });
  }

  void disposeRenderers() async {
    await _localVideoRenderer.dispose();
  }

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
