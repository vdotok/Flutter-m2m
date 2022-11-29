import 'package:flutter/material.dart';
import 'package:vdotok_stream/vdotok_stream.dart';

class RemoteStream extends StatefulWidget {
  const RemoteStream({Key? key, required this.remoteRenderer})
      : super(key: key);
  final RTCVideoRenderer remoteRenderer;

  @override
  _RemoteStreamState createState() => _RemoteStreamState();
}

class _RemoteStreamState extends State<RemoteStream> {

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: RTCVideoView(this.widget.remoteRenderer,
          // key: forsmallView,
          mirror: true,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
    );
  }
}
