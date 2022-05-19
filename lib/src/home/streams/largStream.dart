import 'package:flutter/material.dart';
import 'package:vdotok_stream/vdotok_stream.dart';

class LargStream extends StatefulWidget {
<<<<<<< HEAD
  const LargStream({Key key, this.remoteRenderer}) : super(key: key);
=======
  const LargStream({Key? key, required this.remoteRenderer}) : super(key: key);
>>>>>>> 95fd6584abf96bb0dfe2c53a6712964e820512c0
  final RTCVideoRenderer remoteRenderer;

  @override
  _LargStreamState createState() => _LargStreamState();
}

class _LargStreamState extends State<LargStream> {
//   SignalingClient signalingClient = SignalingClient.instance;
//   // RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();

//   CallProvider _callProvider;
//   // RTCVideoRenderer _remoteRenderer2 = new RTCVideoRenderer();
//   // RTCVideoRenderer _remoteRenderer3 = new RTCVideoRenderer();
//   // RTCVideoRenderer _remoteRenderer4 = new RTCVideoRenderer();
//   String ref_ID;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     _callProvider = Provider.of<CallProvider>(context, listen: false);
//     signalingClient.onLargStream = (stream, refID) {
//       // final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
//       ref_ID = refID;

//       _callProvider.addRenderer(refID, new RTCVideoRenderer());
//       initRenderers();
//       setState(() {
//         _callProvider.remoteRendererList[ref_ID].srcObject = stream;
//         // _time = DateTime.now();
//         // _updateTimer();
//         // _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
//       });
// // Find the Scaffold in the widget tree and use it to show a SnackBar.
//       // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       // print("this is remote stream id ${stream.id}");

//       //here
//       // _callBloc.add(CallStartEvent());
//       _callProvider.callStart();
//     };
//   }

//   initRenderers() async {
//     await _callProvider.remoteRendererList[ref_ID].initialize();
//     // await _remoteRenderer2.initialize();
//     // await _remoteRenderer3.initialize();
//     // await _remoteRenderer4.initialize();
//   }

//   @override
//   dispose() {
//     // _localRenderer.dispose();
//     _callProvider.remoteRendererList[ref_ID].dispose();
//     // _remoteRenderer2.dispose();
//     // _remoteRenderer3.dispose();
//     // _remoteRenderer4.dispose();
//     // _ticker.cancel();
//     super.dispose();
//   }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: RTCVideoView(this.widget.remoteRenderer,
          // key: forsmallView,
          mirror: false,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain),
    );
  }
}
