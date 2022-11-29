import 'package:flutter/material.dart';
import 'package:vdotok_stream/vdotok_stream.dart';

class LargStream extends StatefulWidget {
  const LargStream({Key? key, required this.remoteRenderer}) : super(key: key);
  final RTCVideoRenderer remoteRenderer;

  @override
  _LargStreamState createState() => _LargStreamState();
}

class _LargStreamState extends State<LargStream> {


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: RTCVideoView(this.widget.remoteRenderer,
          // key: forsmallView,
          mirror: true,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain),
    );
  }
}
