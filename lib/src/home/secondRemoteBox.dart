// import 'package:flutter/material.dart';
// import 'package:norgic_vdotok/norgic_vdotok.dart';

// class SecondRemoteBox extends StatefulWidget {
//   const SecondRemoteBox({Key key}) : super(key: key);

//   @override
//   _SecondRemoteBoxState createState() => _SecondRemoteBoxState();
// }

// class _SecondRemoteBoxState extends State<SecondRemoteBox> {
//   RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
//   SignalingClient signalingClient = SignalingClient.instance;

//   bool secondRemoteVideo = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     initRenderers();

//     signalingClient.onRemoteStream1 = (stream) {
//       print("yes i'm here for second remote video");
//       // final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

// // Find the Scaffold in the widget tree and use it to show a SnackBar.
//       // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       // print("this is remote stream id ${stream.id}");
//       setState(() {
//         _remoteRenderer.srcObject = stream;
//         secondRemoteVideo = true;
//         // _time = DateTime.now();
//         // _updateTimer();
//         // _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
//       });
//       //here
//       // _callBloc.add(CallStartEvent());
//       // _callProvider.callStart();
//     };
//   }

//   initRenderers() async {
//     await _remoteRenderer.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Positioned(
//         // left: 225.0,
//         bottom: 145.0,
//         right: 20,
//         child: Align(
//           // alignment: Alignment.bottomRight,
//           child: Container(
//             height: 170,
//             width: 130,
//             decoration: BoxDecoration(
//               color: Colors.green,
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10.0),
//                 child: secondRemoteVideo == false
//                     ? Container()
//                     : RTCVideoView(_remoteRenderer,
//                         // key: forsmallView,
//                         mirror: false,
//                         objectFit:
//                             RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
//                 // : Container(),
//                 ),
//           ),
//         ),
//       ),
//     );
//   }
// }
