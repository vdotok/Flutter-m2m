// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:norgic_vdotok/norgic_vdotok.dart';
// import 'package:norgic_vdotok_example/constant.dart';
// import 'package:norgic_vdotok_example/src/core/providers/auth.dart';
// import 'package:norgic_vdotok_example/src/core/providers/call_provider.dart';
// import 'package:norgic_vdotok_example/src/core/providers/contact_provider.dart';
// import 'package:norgic_vdotok_example/src/core/providers/groupListProvider.dart';
// import 'package:norgic_vdotok_example/src/home/streams/remoteStream.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_grid/responsive_grid.dart';

// class CallingScreen extends StatefulWidget {
//   final params;
//   const CallingScreen({Key key, this.params}) : super(key: key);

//   @override
//   _CallingScreenState createState() => _CallingScreenState();
// }

// class _CallingScreenState extends State<CallingScreen> {
//   bool notmatched = false;
//   bool createGroupScreen = false;

//   DateTime _time;
//   Timer _ticker;
//   String _pressDuration = "";
//   void _updateTimer() {
//     final duration = DateTime.now().difference(_time);
//     final newDuration = _formatDuration(duration);
//     setState(() {
//       _pressDuration = newDuration;
//     });
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) {
//       if (n >= 10) return "$n";
//       return "0$n";
//     }

//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     String twoDigitHours = twoDigits(duration.inHours);
//     if (twoDigitHours == "00")
//       return "$twoDigitMinutes:$twoDigitSeconds";
//     else {
//       return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//     }
//   }

//   SignalingClient signalingClient = SignalingClient.instance;
//   // RTCPeerConnection _peerConnection;
//   // RTCPeerConnection _answerPeerConnection;
//   // MediaStream _localStream;
//   Map<String, RTCVideoRenderer> rtcVideoRendererList = {};
//   List<Map<String, dynamic>> rendererListWithRefID = [
//     // {
//     //   "i": "k",
//     //   "j": "k",
//     // },
//     // {
//     //   "i": "k",
//     //   "j": "k",
//     // }
//   ];
//   GlobalKey forsmallView = new GlobalKey();
//   GlobalKey forlargView = new GlobalKey();
//   GlobalKey forDialView = new GlobalKey();
//   var registerRes;
//   String incomingfrom;
//   CallProvider _callProvider;
//   AuthProvider _auth;
//   bool enableCamera = true;
//   bool switchMute = true;
//   bool switchSpeaker = true;
//   bool secondRemoteVideo = false;
//   String callTo = "";
//   List<int> vibrationList = [
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000,
//     500,
//     1000
//   ];
//   String meidaType = MediaType.video;
//   bool remoteVideoFlag = true;
//   bool remoteAudioFlag = true;
//   ContactProvider _contactProvider;
//   GroupListProvider _groupListProvider;
//   bool localStreamFlag = false;
//   // List<ParticipantsModel> participantsCalling = [];

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // initRenderers();
//     initiateStates();
//     _auth = Provider.of<AuthProvider>(context, listen: false);
//     _contactProvider = Provider.of<ContactProvider>(context, listen: false);
//     _groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
//     print("this is user data auth ${this.widget.params}");
//     _callProvider = Provider.of<CallProvider>(context, listen: false);

//     // _contactBloc = BlocProvider.of<ContactBloc>(context);
//     // _loginBloc = BlocProvider.of<LoginBloc>(context);
//     // _callBloc = BlocProvider.of<CallBloc>(context);
//     // _contactBloc.add(GetContactEvent(widget.user.auth_token));
// //     _groupListProvider.getGroupList(_auth.getUser.auth_token);
// //     _contactProvider.getContacts(_auth.getUser.auth_token);
// //     // signalingClient.closeSocket();
// //     signalingClient.connect();
// //     signalingClient.onConnect = (res) {
// //       print("onConnect $res");
// //       signalingClient.register(_auth.getUser.toJson());
// //       // signalingClient.register(user);
// //     };
// //     signalingClient.onError = (code, res) {
// //       print("onConnect $code $res");
// //       print("hey i am here");
// //       _callProvider.initial();
// //       final snackBar = SnackBar(content: Text(res));

// // // Find the Scaffold in the widget tree and use it to show a SnackBar.
// //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
// //       setState(() {
// //         // _localRenderer.srcObject = null;
// //         // _remoteRenderer.srcObject = null;
// //         // _remoteRenderer2.srcObject = null;
// //         // _remoteRenderer3.srcObject = null;
// //         // _remoteRenderer4.srcObject = null;
// //       });
// //       // signalingClient.register(user);
// //     };
// //     signalingClient.onRegister = (res) {
// //       print("onRegister  $res");
// //       setState(() {
// //         registerRes = res;
// //       });
// //       // signalingClient.register(user);
// //     };
//     // Map<String, dynamic> temp = {
//     //   "refID": _auth.getUser.ref_id,
//     //   "rtcVideoRenderer": new RTCVideoRenderer()
//     // };

//     // initRenderers(temp["rtcVideoRenderer"]);
//     // setState(() {
//     //   rendererListWithRefID.add(this.widget.params["rtcRenderer"]);
//     // });

//     // signalingClient.onLocalStream = (stream) {
//     //   print("this is local stream id ${_auth.getUser.ref_id}");

//     //   setState(() {
//     //     rendererListWithRefID[0]["rtcVideoRenderer"].srcObject = stream;
//     //   });
//     //   setState(() {
//     //     // rendererListWithRefID.add(this.widget.params["rtcRenderer"]);
//     //     localStreamFlag = true;
//     //   });
//     //   _callProvider.callDial();
//     // };
//     signalingClient.onRemoteStream = (stream, refid) async {
//       print("this is remote video");
//       Map<String, dynamic> temp = {
//         "refID": refid,
//         "rtcVideoRenderer": new RTCVideoRenderer()
//       };

//       await initRenderers(temp["rtcVideoRenderer"]);
//       setState(() {
//         temp["rtcVideoRenderer"].srcObject = stream;
//         _time = DateTime.now();
//         _updateTimer();
//         _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
//       });
//       setState(() {
//         rendererListWithRefID.add(temp);
//       });

//       _callProvider.callStart();
//     };

//     // signalingClient.onReceiveCallFromUser = (receivefrom, type) async {
//     //   print("incomming call from user");
//     //   startRinging();

//     //   setState(() {
//     //     incomingfrom = receivefrom;
//     //     meidaType = type;
//     //     switchMute = true;
//     //     enableCamera = true;
//     //     switchSpeaker = type == MediaType.audio ? true : false;
//     //     remoteVideoFlag = true;
//     //     remoteAudioFlag = true;
//     //   });
//     //   _callProvider.callReceive();
//     // };
//     signalingClient.onCallAcceptedByUser = () async {
//       //here
//       // _callBloc.add(CallStartEvent());
//       _callProvider.callStart();
//     };
//     signalingClient.onCallHungUpByUser = () {
//       print("call decliend by other user");
//       //here
//       // _callBloc.add(CallNewEvent());
//       // _callProvider.initial();

//       // stopRinging();
//       Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
//       // disposeAllRenderers();
//     };
//     signalingClient.onCallDeclineByYou = () {
//       //here
//       // _callBloc.add(CallNewEvent());
//       // _callProvider.initial();

//       stopRinging();
//       Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
//       // disposeAllRenderers();
//     };
//     signalingClient.onParticipantsLeft = (refID) {
//       // on participants left
//       if (refID == _auth.getUser.ref_id) {
//       } else {
//         int index = rendererListWithRefID
//             .indexWhere((element) => element["refID"] == refID);
//         rendererListWithRefID[index]["rtcVideoRenderer"].dispose();

//         setState(() {
//           rendererListWithRefID.removeAt(index);
//         });
//       }
//     };
//     signalingClient.onCallBusyCallback = () {
//       print("hey i am here");
//       // _callProvider.initial();
//       final snackBar =
//           SnackBar(content: Text('User is busy with another call.'));

// // Find the Scaffold in the widget tree and use it to show a SnackBar.
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);

//       Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
//       // disposeAllRenderers();
//     };
//     signalingClient.onCallRejectedByUser = () {
//       print("call decliend by other user");
//       //here
//       // _callBloc.add(CallNewEvent());
//       // stopRinging();
//       // _callProvider.initial();

//       Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
//       // disposeAllRenderers();
//     };

//     signalingClient.onAudioVideoStateInfo = (audioFlag, videoFlag, refID) {
//       setState(() {
//         remoteVideoFlag = videoFlag == 0 ? false : true;
//         remoteAudioFlag = audioFlag == 0 ? false : true;
//       });
//     };
//   }

//   initiateStates() {
//     // setState(() {
//     //   incomingfrom = this.widget.params["incomingfrom"];
//     //   meidaType = this.widget.params["incomingfrom"];
//     //   switchMute = true;
//     //   enableCamera = true;
//     //   switchSpeaker =
//     //       this.widget.params["incomingfrom"] == MediaType.audio ? true : false;
//     //   remoteVideoFlag = true;
//     //   remoteAudioFlag = true;
//     // });
//   }

//   initRenderers(RTCVideoRenderer _remoteRenderer) async {
//     await _remoteRenderer.initialize();
//   }

//   disposeAllRenderers() {
//     rendererListWithRefID.forEach((element) {
//       element["rtcVideoRenderer"].dispose();
//     });
//     rendererListWithRefID.clear();
//   }

//   stopCall() {
//     print("this is mcToken on Stop ${_auth.getUser} ");
//     Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
//     signalingClient.stopCall(_auth.getUser.resgisterRes["mcToken"]);
//     //here
//     // _callBloc.add(CallNewEvent());
//     // _callProvider.initial();
//     // disposeAllRenderers();
//     if (!kIsWeb) stopRinging();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     disposeAllRenderers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Consumer<CallProvider>(
//         builder: (context, callProvider, child) {
//           print("this is callStatus ${callProvider.callStatus}");
//           if (callProvider.callStatus == CallStatus.CallReceive)
//             return callReceive();

//           if (callProvider.callStatus == CallStatus.CallStart)
//             return callStart();
//           if (callProvider.callStatus == CallStatus.CallDial)
//             return callDial();
//           else
//             return Scaffold(
//                 body: Container(
//               child: Text("this is text"),
//             ));
//         },
//       ),
//     );
//   }

//   stopRinging() {
//     // print("this is on rejected ");
//     // // startRinging();
//     // vibrationList.clear();
//     // // });
//     // Vibration.cancel();
//     // FlutterRingtonePlayer.stop();

//     // // setState(() {
//   }

//   Scaffold callReceive() {
//     return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
//       return Stack(children: <Widget>[
//         this.widget.params["mediaType"] == MediaType.video
//             ? Container(
//                 child: RTCVideoView(
//                     this.widget.params["rtcRenderer"]["rtcVideoRenderer"],
//                     key: forlargView,
//                     mirror: false,
//                     objectFit:
//                         RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
//               )
//             : Container(
//                 decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                   colors: [
//                     backgroundAudioCallDark,
//                     backgroundAudioCallLight,
//                     backgroundAudioCallLight,
//                     backgroundAudioCallLight,
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment(0.0, 0.0),
//                 )),
//                 child: Center(
//                   child: SvgPicture.asset(
//                     'assets/userIconCall.svg',
//                   ),
//                 ),
//               ),
//         Container(
//           padding: EdgeInsets.only(top: 120),
//           alignment: Alignment.center,
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 "Incoming Call from",
//                 style: TextStyle(
//                     fontSize: 14,
//                     decoration: TextDecoration.none,
//                     fontFamily: secondaryFontFamily,
//                     fontWeight: FontWeight.w400,
//                     fontStyle: FontStyle.normal,
//                     color: darkBlackColor),
//               ),
//               SizedBox(
//                 height: 8,
//               ),
//               Consumer<ContactProvider>(
//                 builder: (context, contact, child) {
//                   if (contact.contactState == ContactStates.Success) {
//                     int index = contact.contactList.users.indexWhere(
//                         (element) =>
//                             element.ref_id ==
//                             this.widget.params["incomingfrom"]);
//                     print("callto is $callTo");
//                     print(
//                         "incoming ${index == -1 ? this.widget.params["incomingfrom"] : contact.contactList.users[index].full_name}");
//                     return Text(
//                       index == -1
//                           ? this.widget.params["incomingfrom"]
//                           : contact.contactList.users[index].full_name,
//                       style: TextStyle(
//                           fontFamily: primaryFontFamily,
//                           color: darkBlackColor,
//                           decoration: TextDecoration.none,
//                           fontWeight: FontWeight.w700,
//                           fontStyle: FontStyle.normal,
//                           fontSize: 24),
//                     );
//                   } else
//                     return Container();
//                 },
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(
//             bottom: 56,
//           ),
//           alignment: Alignment.bottomCenter,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 child: SvgPicture.asset(
//                   'assets/end.svg',
//                 ),
//                 onTap: () {
//                   stopRinging();
//                   signalingClient.onDeclineCall(_auth.getUser.ref_id,
//                       _auth.getUser.resgisterRes["mcToken"]);
//                   // _callBloc.add(CallNewEvent());
//                   // _callProvider.initial();
//                   // signalingClient.onDeclineCall(widget.registerUser);
//                   // setState(() {
//                   //   _isCalling = false;
//                   // });
//                 },
//               ),
//               SizedBox(width: 64),
//               GestureDetector(
//                 child: SvgPicture.asset(
//                   'assets/Accept.svg',
//                 ),
//                 onTap: () {
//                   stopRinging();
//                   signalingClient.createAnswer(incomingfrom);
//                   // _callProvider.callStart();
//                   // setState(() {
//                   //   _isCalling = true;
//                   //   incomingfrom = null;
//                   // });
//                   // FlutterRingtonePlayer.stop();
//                   // Vibration.cancel();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ]);
//     }));
//     //   floatingActionButton: Padding(
//     //     padding: const EdgeInsets.only(bottom: 70),
//     //     child: Row(
//     //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     //       children: <Widget>[
//     //         Container(
//     //           // width: 80,
//     //           // height: 80,
//     //           child: FloatingActionButton(
//     //             backgroundColor: redColor,
//     //             onPressed: () {
//     //               stopRinging();
//     //               signalingClient.onDeclineCall(_auth.getUser.ref_id);
//     //               // _callBloc.add(CallNewEvent());
//     //               _callProvider.initial();
//     //               // signalingClient.onDeclineCall(widget.registerUser);
//     //               // setState(() {
//     //               //   _isCalling = false;
//     //               // });
//     //             },
//     //             child: Icon(Icons.clear),
//     //           ),
//     //         ),
//     //         Container(
//     //           // width: 80,
//     //           // height: 80,
//     //           child: FloatingActionButton(
//     //             backgroundColor: Colors.green,
//     //             onPressed: () {
//     //               stopRinging();
//     //               signalingClient.createAnswer(incomingfrom);
//     //               // setState(() {
//     //               //   _isCalling = true;
//     //               //   incomingfrom = null;
//     //               // });
//     //               // FlutterRingtonePlayer.stop();
//     //               // Vibration.cancel();
//     //             },
//     //             child: Icon(Icons.phone),
//     //           ),
//     //         )
//     //       ],
//     //     ),
//     //   ),
//     //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     // );
//   }

//   Scaffold callDial() {
//     print(
//         "ths is width ${rendererListWithRefID[0]["refID"]}, ${MediaQuery.of(context).size.width}");
//     return Scaffold(
//       body: OrientationBuilder(builder: (context, orientation) {
//         return Stack(
//           children: [
//             this.widget.params["mediaType"] == MediaType.video
//                 ? Container(
//                     // color: Colors.red,
//                     //margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                     child: localStreamFlag
//                         ? RemoteStream(
//                             remoteRenderer: rendererListWithRefID[0]
//                                 ["rtcVideoRenderer"],
//                           )
//                         : Container(),
//                   )
//                 : Container(
//                     decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                       colors: [
//                         backgroundAudioCallDark,
//                         backgroundAudioCallLight,
//                         backgroundAudioCallLight,
//                         backgroundAudioCallLight,
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment(0.0, 0.0),
//                     )),
//                     child: Center(
//                       child: SvgPicture.asset(
//                         'assets/userIconCall.svg',
//                       ),
//                     ),
//                   ),
//             // : Container(
//             //     decoration: BoxDecoration(
//             //         gradient: LinearGradient(
//             //       colors: [
//             //         backgroundAudioCallDark,
//             //         backgroundAudioCallLight,
//             //         backgroundAudioCallLight,
//             //         backgroundAudioCallLight,
//             //       ],
//             //       begin: Alignment.topCenter,
//             //       end: Alignment(0.0, 0.0),
//             //     )),
//             //     child: Center(
//             //       child: SvgPicture.asset(
//             //         'assets/userIconCall.svg',
//             //       ),
//             //     ),
//             //   ),

//             Container(
//                 padding: EdgeInsets.only(top: 120),
//                 alignment: Alignment.center,
//                 child: Column(
//                     // mainAxisAlignment: MainAxisAlignment.center,
//                     // crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Calling",
//                         style: TextStyle(
//                             fontSize: 14,
//                             decoration: TextDecoration.none,
//                             fontFamily: secondaryFontFamily,
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             color: darkBlackColor),
//                       ),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: this.widget.params["to"].length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 this.widget.params["to"][index].full_name,
//                                 style: TextStyle(
//                                     fontFamily: primaryFontFamily,
//                                     color: darkBlackColor,
//                                     decoration: TextDecoration.none,
//                                     fontWeight: FontWeight.w700,
//                                     fontStyle: FontStyle.normal,
//                                     fontSize: 24),
//                               ),
//                             );
//                           },
//                         ),
//                       )
//                     ])),

//             // Container(
//             //   height: 79,
//             //   //width: MediaQuery.of(context).size.width,
//             //   padding: EdgeInsets.only(
//             //     left: 20,
//             //   ),
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     crossAxisAlignment: CrossAxisAlignment.start,
//             //     children: [
//             //       Text(
//             //         callTo,
//             //         style: TextStyle(
//             //             fontSize: 14,
//             //             decoration: TextDecoration.none,
//             //             fontFamily: secondaryFontFamily,
//             //             fontWeight: FontWeight.w400,
//             //             fontStyle: FontStyle.normal,
//             //             color: darkBlackColor),
//             //       ),
//             //       Container(
//             //         padding: EdgeInsets.only(
//             //           right: 25,
//             //         ),
//             //         child: Row(
//             //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //           crossAxisAlignment: CrossAxisAlignment.end,
//             //           children: [
//             //             Text(
//             //               'Dialing...',
//             //               style: TextStyle(
//             //                   fontFamily: primaryFontFamily,
//             //                   // background: Paint()..color = yellowColor,
//             //                   color: darkBlackColor,
//             //                   decoration: TextDecoration.none,
//             //                   fontWeight: FontWeight.w700,
//             //                   fontStyle: FontStyle.normal,
//             //                   fontSize: 24),
//             //             ),
//             //             // Text(
//             //             //   "00:00",
//             //             //   style: TextStyle(
//             //             //       decoration: TextDecoration.none,
//             //             //       fontSize: 14,
//             //             //       fontFamily: secondaryFontFamily,
//             //             //       fontWeight: FontWeight.w400,
//             //             //       fontStyle: FontStyle.normal,
//             //             //       color: Colors.black),
//             //             // ),
//             //           ],
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             Container(
//               padding: EdgeInsets.only(bottom: 56),
//               alignment: Alignment.bottomCenter,
//               child: GestureDetector(
//                 child: SvgPicture.asset(
//                   'assets/end.svg',
//                 ),
//                 onTap: () {
//                   signalingClient.onCancelbytheCaller(
//                       _auth.getUser.resgisterRes["mcToken"]);
//                   Navigator.pushNamedAndRemoveUntil(
//                       context, "/home", (route) => false);
//                   _callProvider.initial();

//                   // _callBloc.add(CallNewEvent());
//                   // signalingClient.onDeclineCall(widget.user.ref_id);
//                   // setState(() {
//                   //   _isCalling = false;
//                   // });
//                 },
//               ),
//             ),
//           ],
//         );
//       }),
//       // floatingActionButton: Padding(
//       //   padding: const EdgeInsets.only(bottom: 70),
//       //   child: Row(
//       //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //     children: <Widget>[
//       //       Container(
//       //         // width: 80,
//       //         // height: 80,
//       //         child: FloatingActionButton(
//       //           backgroundColor: redColor,
//       //           onPressed: () {
//       //             signalingClient.onCancelbytheCaller(registerRes["mcToken"]);
//       //             _callProvider.initial();
//       //             // _callBloc.add(CallNewEvent());
//       //             // signalingClient.onDeclineCall(widget.user.ref_id);
//       //             // setState(() {
//       //             //   _isCalling = false;
//       //             // });
//       //           },
//       //           child: Icon(Icons.clear),
//       //         ),
//       //       )
//       //     ],
//       //   ),
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }

//   Scaffold callStart() {
//     final double itemHeight = (MediaQuery.of(context).size.height - 24) / 2;
//     final double itemWidth = MediaQuery.of(context).size.width / 2;
//     return Scaffold(
//       body: OrientationBuilder(builder: (context, orientation) {
//         return Container(
//           child: Stack(children: <Widget>[
//             // Positioned(
//             //     left: 0.0,
//             //     right: 0.0,
//             //     top: 0.0,
//             //     bottom: 0.0,
//             //     child: Container(
//             //       margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//             //       width: MediaQuery.of(context).size.width,
//             //       height: MediaQuery.of(context).size.height,
//             //       child:
//             meidaType == MediaType.video
//                 ? rendererListWithRefID.length == 1
//                     ? RemoteStream(
//                         remoteRenderer: rendererListWithRefID[0]
//                             ["rtcVideoRenderer"],
//                       )
//                     : rendererListWithRefID.length == 2
//                         ? Column(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                     color: Colors.yellow,
//                                     width: MediaQuery.of(context).size.width,
//                                     child: RemoteStream(
//                                       remoteRenderer: rendererListWithRefID[0]
//                                           ["rtcVideoRenderer"],
//                                     )),
//                               ),
//                               Expanded(
//                                 child: Container(
//                                     color: Colors.green,
//                                     width: MediaQuery.of(context).size.width,
//                                     child: RemoteStream(
//                                       remoteRenderer: rendererListWithRefID[1]
//                                           ["rtcVideoRenderer"],
//                                     )),
//                               )
//                             ],
//                           )
//                         : rendererListWithRefID.length == 3
//                             ? Column(
//                                 children: [
//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                             color: Colors.yellow,
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 2,
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height /
//                                                 2,
//                                             child: RemoteStream(
//                                               remoteRenderer:
//                                                   rendererListWithRefID[0]
//                                                       ["rtcVideoRenderer"],
//                                             )),
//                                         Container(
//                                           color: Colors.yellow,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               2,
//                                           height: MediaQuery.of(context)
//                                                   .size
//                                                   .height /
//                                               2,
//                                           child: RemoteStream(
//                                             remoteRenderer:
//                                                 rendererListWithRefID[1]
//                                                     ["rtcVideoRenderer"],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Container(
//                                       color: Colors.green,
//                                       width: MediaQuery.of(context).size.width,
//                                       child: RemoteStream(
//                                         remoteRenderer: rendererListWithRefID[2]
//                                             ["rtcVideoRenderer"],
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               )
//                             : Column(
//                                 children: [
//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                             color: Colors.yellow,
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 2,
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height /
//                                                 2,
//                                             child: RemoteStream(
//                                               remoteRenderer:
//                                                   rendererListWithRefID[0]
//                                                       ["rtcVideoRenderer"],
//                                             )),
//                                         Container(
//                                           color: Colors.yellow,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               2,
//                                           height: MediaQuery.of(context)
//                                                   .size
//                                                   .height /
//                                               2,
//                                           child: RemoteStream(
//                                             remoteRenderer:
//                                                 rendererListWithRefID[1]
//                                                     ["rtcVideoRenderer"],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                             color: Colors.yellow,
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 2,
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height /
//                                                 2,
//                                             child: RemoteStream(
//                                               remoteRenderer:
//                                                   rendererListWithRefID[2]
//                                                       ["rtcVideoRenderer"],
//                                             )),
//                                         Container(
//                                           color: Colors.yellow,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               2,
//                                           height: MediaQuery.of(context)
//                                                   .size
//                                                   .height /
//                                               2,
//                                           child: RemoteStream(
//                                             remoteRenderer:
//                                                 rendererListWithRefID[3]
//                                                     ["rtcVideoRenderer"],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               )

//                 // RTCVideoView(rendererListWithRefID[0]["refID"],
//                 //     mirror: false,
//                 //     objectFit: kIsWeb
//                 //         ? RTCVideoViewObjectFit.RTCVideoViewObjectFitContain
//                 //         : RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
//                 // : Container(
//                 //     decoration: BoxDecoration(
//                 //         gradient: LinearGradient(
//                 //       colors: [
//                 //         backgroundAudioCallDark,
//                 //         backgroundAudioCallLight,
//                 //         backgroundAudioCallLight,
//                 //         backgroundAudioCallLight,
//                 //       ],
//                 //       begin: Alignment.topCenter,
//                 //       end: Alignment(0.0, 0.0),
//                 //     )),
//                 //     child: Center(
//                 //       child: SvgPicture.asset(
//                 //         'assets/userIconCall.svg',
//                 //       ),
//                 //     ),
//                 //   )
//                 : Container(
//                     decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                       colors: [
//                         backgroundAudioCallDark,
//                         backgroundAudioCallLight,
//                         backgroundAudioCallLight,
//                         backgroundAudioCallLight,
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment(0.0, 0.0),
//                     )),
//                     child: Center(
//                       child: SvgPicture.asset(
//                         'assets/userIconCall.svg',
//                       ),
//                     ),
//                   ),

//             Container(
//               padding: EdgeInsets.only(top: 55, left: 20),
//               //height: 79,
//               //width: MediaQuery.of(context).size.width,

//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'You are video calling with',
//                     style: TextStyle(
//                         fontSize: 14,
//                         decoration: TextDecoration.none,
//                         fontFamily: secondaryFontFamily,
//                         fontWeight: FontWeight.w400,
//                         fontStyle: FontStyle.normal,
//                         color: darkBlackColor),
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(
//                       right: 25,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         //            Consumer<ContactProvider>(
//                         //   builder: (context, contact, child) {
//                         //     if (contact.contactState == ContactStates.Success) {
//                         //       int index = contact.contactList.users.indexWhere(
//                         //           (element) => element.ref_id == incomingfrom);
//                         //       return Text(
//                         //         contact.contactList.users[index].full_name,
//                         //         style: TextStyle(
//                         //             fontFamily: primaryFontFamily,
//                         //             color: darkBlackColor,
//                         //             decoration: TextDecoration.none,
//                         //             fontWeight: FontWeight.w700,
//                         //             fontStyle: FontStyle.normal,
//                         //             fontSize: 24),
//                         //       );
//                         //     }
//                         //   },
//                         // ),
//                         // (callTo == "")
//                         //     ? Consumer<ContactProvider>(
//                         //         builder: (context, contact, child) {
//                         //         if (contact.contactState ==
//                         //             ContactStates.Success) {
//                         //           int index = contact.contactList.users
//                         //               .indexWhere((element) =>
//                         //                   element.ref_id == incomingfrom);
//                         //           print("i am here-");
//                         //           return Text(
//                         //             contact.contactList.users[index].full_name,
//                         //             style: TextStyle(
//                         //                 fontFamily: primaryFontFamily,
//                         //                 color: darkBlackColor,
//                         //                 decoration: TextDecoration.none,
//                         //                 fontWeight: FontWeight.w700,
//                         //                 fontStyle: FontStyle.normal,
//                         //                 fontSize: 24),
//                         //           );
//                         //         } else {
//                         //           return Container();
//                         //         }
//                         //       })
//                         //     : Text(
//                         //         callTo,
//                         //         style: TextStyle(
//                         //             fontFamily: primaryFontFamily,
//                         //             // background: Paint()..color = yellowColor,
//                         //             color: darkBlackColor,
//                         //             decoration: TextDecoration.none,
//                         //             fontWeight: FontWeight.w700,
//                         //             fontStyle: FontStyle.normal,
//                         //             fontSize: 24),
//                         //       ),
//                         Text(
//                           _pressDuration,
//                           style: TextStyle(
//                               decoration: TextDecoration.none,
//                               fontSize: 14,
//                               fontFamily: secondaryFontFamily,
//                               fontWeight: FontWeight.w400,
//                               fontStyle: FontStyle.normal,
//                               color: darkBlackColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             !kIsWeb
//                 ? meidaType == MediaType.video
//                     ? Container(
//                         // color: Colors.red,
//                         child: Column(
//                           children: [
//                             Padding(
//                               // height: 500,
//                               // width: 500,
//                               // padding: EdgeInsets.zero,
//                               padding: const EdgeInsets.fromLTRB(
//                                   327.0, 120.0, 25.0, 8.0),
//                               child: Align(
//                                 alignment: Alignment.topRight,
//                                 child: GestureDetector(
//                                   child: SvgPicture.asset(
//                                       'assets/switch_camera.svg'),
//                                   onTap: () {
//                                     signalingClient.switchCamera();
//                                   },
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               // padding: EdgeInsets.zero,
//                               // height: 500,
//                               // width: 500,
//                               padding: const EdgeInsets.fromLTRB(
//                                   327.0, 10.0, 20.0, 8.0),
//                               child: Align(
//                                 alignment: Alignment.topRight,
//                                 child: GestureDetector(
//                                   child: switchSpeaker
//                                       ? SvgPicture.asset('VolumnOn.svg')
//                                       : SvgPicture.asset(
//                                           'assets/VolumeOff.svg'),
//                                   onTap: () {
//                                     signalingClient
//                                         .switchSpeaker(switchSpeaker);
//                                     setState(() {
//                                       switchSpeaker = !switchSpeaker;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : Container(
//                         // color: Colors.red,
//                         child: Column(
//                           children: [
//                             Padding(
//                               // padding: EdgeInsets.zero,
//                               // height: 500,
//                               // width: 500,
//                               padding: const EdgeInsets.fromLTRB(
//                                   327.0, 120.0, 20.0, 8.0),
//                               child: Align(
//                                 alignment: Alignment.topRight,
//                                 child: GestureDetector(
//                                   child: switchSpeaker
//                                       ? SvgPicture.asset('assets/VolumnOn.svg')
//                                       : SvgPicture.asset(
//                                           'assets/VolumeOff.svg'),
//                                   onTap: () {
//                                     signalingClient
//                                         .switchSpeaker(switchSpeaker);
//                                     setState(() {
//                                       switchSpeaker = !switchSpeaker;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                 : SizedBox(),

//             Positioned(
//               left: 20.0,
//               bottom: 145.0,
//               // right: 20,
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   height: 170,
//                   width: 130,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10.0),
//                       child: RemoteStream(
//                         remoteRenderer: this.widget.params["rtcRenderer"]
//                             ["rtcVideoRenderer"],
//                       )

//                       // RTCVideoView(_remoteRenderer,
//                       //     // key: forsmallView,
//                       //     mirror: false,
//                       //     objectFit: RTCVideoViewObjectFit
//                       //         .RTCVideoViewObjectFitCover),
//                       ),
//                 ),
//               ),
//             ),

//             Positioned(
//               // left: 225.0,
//               bottom: 145.0,
//               right: 20,
//               child: Align(
//                 // alignment: Alignment.bottomRight,
//                 child: Container(
//                   height: 170,
//                   width: 130,
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10.0),
//                     child:
//                         // RemoteStream(
//                         //   remoteRenderer: _remoteRenderer,
//                         // )
//                         Container(),
//                   ),
//                 ),
//               ),
//             ),

//             Container(
//               padding: EdgeInsets.only(
//                 bottom: 56,
//               ),
//               alignment: Alignment.bottomCenter,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   meidaType == MediaType.video
//                       ? Row(
//                           children: [
//                             GestureDetector(
//                               child: !enableCamera
//                                   ? SvgPicture.asset('assets/video_off.svg')
//                                   : SvgPicture.asset('assets/video.svg'),
//                               onTap: () {
//                                 setState(() {
//                                   enableCamera = !enableCamera;
//                                 });
//                                 signalingClient.audioVideoState(
//                                     audioFlag: switchMute ? 1 : 0,
//                                     videoFlag: enableCamera ? 1 : 0,
//                                     mcToken:
//                                         _auth.getUser.resgisterRes["mcToken"]);
//                                 signalingClient.enableCamera(enableCamera);
//                               },
//                             ),
//                             SizedBox(
//                               width: 20,
//                             )
//                           ],
//                         )
//                       : SizedBox(),
//                   // : Container(),

//                   // FloatingActionButton(
//                   //   backgroundColor:
//                   //       switchSpeaker ? chatRoomColor : Colors.white,
//                   //   elevation: 0.0,
//                   //   onPressed: () {
//                   //     setState(() {
//                   //       switchSpeaker = !switchSpeaker;
//                   //     });
//                   //     signalingClient.switchSpeaker(switchSpeaker);
//                   //   },
//                   //   child: switchSpeaker
//                   //       ? Icon(Icons.volume_up)
//                   //       : Icon(
//                   //           Icons.volume_off,
//                   //           color: chatRoomColor,
//                   //         ),
//                   // ),
//                   // SizedBox(
//                   //   width: 20,
//                   // ),
//                   GestureDetector(
//                     child: SvgPicture.asset(
//                       'assets/end.svg',
//                     ),
//                     onTap: () {
//                       stopCall();
//                       // setState(() {
//                       //   _isCalling = false;
//                       // });
//                     },
//                   ),

//                   // SvgPicture.asset('assets/images/end.svg'),

//                   SizedBox(width: 20),
//                   GestureDetector(
//                     child: !switchMute
//                         ? SvgPicture.asset('assets/mute_microphone.svg')
//                         : SvgPicture.asset('assets/microphone.svg'),
//                     onTap: () {
//                       final bool enabled = signalingClient.muteMic();
//                       print("this is enabled $enabled");
//                       setState(() {
//                         switchMute = enabled;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             )
//           ]),
//         );
//       }),

//       // floatingActionButton: Padding(
//       //   padding: const EdgeInsets.only(bottom: 50),
//       //   child: Row(
//       //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //       children: <Widget>[
//       //         FloatingActionButton(
//       //           backgroundColor: !switchMute ? redColor : Colors.grey,
//       //           onPressed: () {
//       //             final bool enabled = signalingClient.muteMic();
//       //             print("this is enabled $enabled");
//       //             setState(() {
//       //               switchMute = enabled;
//       //             });
//       //           },
//       //           child: !switchMute ? Icon(Icons.mic_off) : Icon(Icons.mic),
//       //         ),
//       //         FloatingActionButton(
//       //           backgroundColor: switchSpeaker ? redColor : Colors.grey,
//       //           onPressed: () {
//       //             setState(() {
//       //               switchSpeaker = !switchSpeaker;
//       //             });
//       //             signalingClient.switchSpeaker(switchSpeaker);
//       //           },
//       //           child: Icon(Icons.volume_up),
//       //         ),
//       //         FloatingActionButton(
//       //           backgroundColor: !enableCamera ? redColor : Colors.grey,
//       //           onPressed: () {
//       // setState(() {
//       //   enableCamera = !enableCamera;
//       // });
//       // signalingClient.enableCamera(enableCamera);
//       //           },
//       //           child: Icon(Icons.videocam_off),
//       //         ),
//       //         FloatingActionButton(
//       //           backgroundColor: Colors.grey,
//       //           onPressed: () {
//       //             signalingClient.switchCamera();
//       //           },
//       //           child: Icon(Icons.loop),
//       //         ),
//       //         Container(
//       //           // width: 80,
//       //           // height: 80,
//       //           child: FloatingActionButton(
//       //             onPressed: () {
//       // stopCall();
//       // // setState(() {
//       // //   _isCalling = false;
//       // // });
//       //             },
//       //             child: Icon(Icons.phone),
//       //           ),
//       //         )
//       //       ]),
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }
