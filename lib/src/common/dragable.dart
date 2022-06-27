import 'package:flutter/material.dart';
import 'package:vdotok_stream/core/interface/enums.dart';
import 'package:vdotok_stream/core/native/rtc_video_view_impl.dart';
import 'package:vdotok_stream_example/src/home/home.dart';

import '../home/streams/remoteStream.dart';
// List<Map<String, dynamic>> rendererListWithRefid = [];

class DragBox extends StatefulWidget {
  final Offset initPos;
  final rendererListWithRefid;

  DragBox({required this.initPos, required this.rendererListWithRefid});

  @override
  DragBoxState createState() => DragBoxState();
}

class DragBoxState extends State<DragBox> {
  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: position.dx,
        top: position.dy,
        child: Draggable(
          // data: widget.itemColor,
          child: Container(
            height: 170,
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10) // green as background color
                    ),
                child: RTCVideoView(
                    widget.rendererListWithRefid[0]["rtcVideoRenderer"],
                    key: forsmallView,
                    mirror: false,
                    objectFit:
                        RTCVideoViewObjectFit.RTCVideoViewObjectFitContain)),
          ),
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              position = offset;
              print("dro");
            });
          },
          feedback: Container(
            height: 170,
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10) // green as background color
                    ),
                child: RTCVideoView(
                    widget.rendererListWithRefid[0]["rtcVideoRenderer"],
                    key: forsmallView,
                    mirror: false,
                    objectFit:
                        RTCVideoViewObjectFit.RTCVideoViewObjectFitContain)),
          ),
        ));
  }
}
