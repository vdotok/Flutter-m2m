import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:vdotok_stream_example/src/core/providers/call_provider.dart';
// import 'package:vdotok_stream_example/src/core/providers/contact_provider.dart';
// import 'package:vdotok_stream_example/src/core/providers/groupListProvider.dart';
import 'src/core/providers/auth.dart';
import 'src/core/providers/call_provider.dart';
import 'src/core/providers/contact_provider.dart';
import 'src/core/providers/groupListProvider.dart';
import 'src/home/homeIndex.dart';
import 'src/login/SignInScreen.dart';
import 'src/routing/routes.dart';
import 'src/splash/splash.dart';
import 'package:provider/provider.dart';
import 'constant.dart';

GlobalKey<ScaffoldMessengerState>? rootScaffoldMessengerKey;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _desc = '';
  @override
  void initState() {
    super.initState();

    rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  }

  @override
  void deactivate() {
    super.deactivate();
    print("this is deactivated of main");
  }

  @override
  void dispose() {
    super.dispose();
    print("main dispose method");
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..isUserLogedIn()),
        ChangeNotifierProvider(create: (_) => CallProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => GroupListProvider()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Vdotok Video',
        theme: ThemeData(
            primaryColor: primaryColor,
            scaffoldBackgroundColor: Colors.white,
            textTheme: TextTheme(
              bodyText1: TextStyle(color: secondaryColor),
              bodyText2: TextStyle(color: secondaryColor),
            ),
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: primaryColor)),
        onGenerateRoute: Routers.generateRoute,
        home: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            if (auth.loggedInStatus == Status.Authenticating)
              return SplashScreen();
            else if (auth.loggedInStatus == Status.LoggedIn) {
              //return Test();
              return HomeIndex();
            } else
              return SignInScreen();
          },
          // ),
        ),
      ),
    );
  }
}
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutterm2m/constant.dart';
// // import 'package:vdotok_stream/vdotok_stream.dart';
// // // import 'package:vdotok_stream_example/constant.dart';
// // // import 'package:vdotok_stream_example/constants.dart';

// // import 'package:web_socket_channel/web_socket_channel.dart';

// // class MyHttpOverrides extends HttpOverrides {
// //   @override
// //   HttpClient createHttpClient(SecurityContext? context) {
// //     return super.createHttpClient(context)
// //       ..badCertificateCallback =
// //           (X509Certificate cert, String host, int port) => true;
// //   }
// // }

// // void main() {
// //   HttpOverrides.global = MyHttpOverrides();
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //         debugShowCheckedModeBanner: false,
// //         title: 'Vdotok Video',
// //         theme: ThemeData(
// //             colorScheme: ColorScheme.fromSwatch(
// //               primarySwatch: Colors.grey,
// //             ).copyWith(),
// //             // accentColor: primaryColor,
// //             primaryColor: primaryColor,
// //             scaffoldBackgroundColor: Colors.white,
// //             textTheme: TextTheme(
// //               bodyText1: TextStyle(color: secondaryColor),
// //               bodyText2: TextStyle(color: secondaryColor), //Text
// //             )),
// //         // onGenerateRoute: Routers.generateRoute,
// //         home: Test());
// //   }
// // }

// // class Test extends StatefulWidget {
// //   @override
// //   _TestState createState() => _TestState();
// // }

// // class _TestState extends State<Test> {
// //   SignalingClient? signalingClient;
// //   MediaStream? _localStream;
// //   RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
// //   RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
// //   int? fullScreenIndex;
// //   late TextEditingController _controller;
// //   late TextEditingController _controllerSecondSession;
// //   late TextEditingController _controllerAuth;
// //   late TextEditingController _controllerAutherizationToken;
// //   String userName = "";
// //   String status = "";
// //   // bnn
// //   String vdotokRef = "8786BUCWb04e55cd8e1b05890c2a40ac460faa67";
// //   String vdotokAuth = "8a9c39dc89353a5442ed415270692d4d";
// // // dnn
// //   String vdotok1Ref = "8786BUCWfeca4215d2364cda1b4d278b2319d7ee";
// //   String vdotok1Auth = "2fff8e9ccb599ea135c6ed7a39edb042";
// // // Hnn
// //   String vdotok2Ref = "8786BUCW447b39026c9bd3dee7c96f8aea863cad";
// //   String vdotok2Auth = "bb682b87ad1bcf632d650a3c81d669a4";

// //   String vdotok3Ref = "";
// //   String vdotok3Auth = "";

// //   Map<String, Session> sessionList = {};
// //   bool incommingSession = false;

// //   @override
// //   void initState() {
// //     // TODO: implement initState

// //     // initRenderers();
// //     _controller = TextEditingController();
// //     _controllerSecondSession = TextEditingController();
// //     _controllerAuth = TextEditingController();
// //     _controllerAutherizationToken = TextEditingController();
// //     signalingClient = SignalingClient.instance;
// //     _controllerSecondSession.text = vdotokRef;
// //     _controllerAutherizationToken.text = vdotokRef;

// //     // signalingClient.methodInvoke();
// //     super.initState();
// //     // initRenderers();

// //     signalingClient?.onLocalStream = (stream) {
// //       setState(() {
// //         _localRenderer = stream;
// //       });
// //     };
// //     signalingClient?.onRegister = (res) {
// //       print("on Register $res");
// //       setState(() {
// //         status = "Connected";
// //       });
// //     };
// //     signalingClient?.onInComingCall = (d) {
// //       setState(() {
// //         incommingSession = true;
// //       });
// //     };
// //     signalingClient?.onLocalAudioVideoStates = (res) {
// //       print("on onLocalAudioVideoStates $res");
// //     };
// //     signalingClient?.onAddRemoteStream = (sessionMap) {
// //       setState(() {
// //         sessionList = sessionMap!;
// //       });

// //       // int indexat =
// //       //     sessionList.indexWhere((element) => (element.to == session.to));
// //       // if (indexat != -1) {
// //       //   setState(() {
// //       //     sessionList[indexat].remoteRenderer = session.remoteRenderer;
// //       //   });
// //       // }
// //     };

// //     signalingClient?.onCallStateChange =
// //         (Map<String, Session>? SessionMap, CallState state) async {
// //       print("this is call State $state");

// //       switch (state) {
// //         case CallState.CallStateNew:
// //           break;
// //         case CallState.CallSession:
// //           {
// //             // int indexat = sessionList
// //             //     .indexWhere((element) => (element.to == session!.to));
// //             // if (indexat == -1) {
// //             setState(() {
// //               sessionList = SessionMap!;
// //             });
// //           }

// //           break;
// //         case CallState.CallStateRinging:
// //           {
// //             setState(() {
// //               incommingSession = true;
// //             });
// //             // setState(() {
// //             //   _session = session;
// //             //   mediaType = session!.mediaType!;
// //             // });
// //             // _callProvider!.callReceive();
// //           }
// //           break;
// //         case CallState.CallStateBye:
// //           {
// //             if (SessionMap == null) {
// //               // sessionList.forEach((element) async {
// //               //   await element.remoteRenderer.dispose();
// //               // });
// //               setState(() {
// //                 if (_localRenderer.srcObject != null) {
// //                   _localRenderer.srcObject = null;
// //                 }
// //                 sessionList.clear();
// //                 incommingSession = false;
// //               });
// //             } else {
// //               setState(() {
// //                 sessionList.remove(SessionMap.keys.first);
// //               });
// //             }
// //           }
// //           break;
// //         case CallState.ParticipantLeft:
// //           {
// //             if (SessionMap != null) {
// //               setState(() {
// //                 sessionList.remove(SessionMap.keys.first);
// //               });
// //             }
// //             // if (session == null) {
// //             // } else {
// //             //   int index = sessionList
// //             //       .indexWhere((element) => element.to == session!.to);
// //             //   // print("this is index $index");
// //             //   // await sessionList[index].remoteRenderer.dispose();
// //             //   setState(() {
// //             //     sessionList.removeAt(index);
// //             //   });
// //             // }
// //           }
// //           break;
// //         case CallState.CallStateInvite:
// //           // _callProvider!.callDial();
// //           break;
// //         case CallState.CallStateConnected:
// //           {
// //             // _callticker?.cancel();
// //             // _time = DateTime.now();
// //             // print(
// //             //     "this is current time......... $_time......this is calll start time");
// //             // _ticker = Timer.periodic(Duration(seconds: 1), (_) => _getTimer());
// //             // print("ticker is $_ticker");

// //             // _callProvider!.callStart();
// //             // setState(() {
// //             //   _remoteRenderer = session!.remoteRenderer;
// //             // });
// //           }

// //           break;
// //       }
// //     };

// //     // signalingClient?.onRemoteStream = (stream, d) {
// //     //   print("this is local stream ${stream}");
// //     //   if (_localRenderer.srcObject == null) {
// //     //     setState(() {
// //     //       _localRenderer.srcObject = stream;
// //     //     });
// //     //   } else {
// //     //     setState(() {
// //     //       _screenShareRenderer.srcObject = stream;
// //     //     });
// //     //   }
// //     // };
// //     // signalingClient.getPermissions();
// //   }

// //   Future<void> initRenderers() async {
// //     // if (type == "screen") {
// //     await _remoteRenderer.initialize();
// //     // } else {
// //     await _localRenderer.initialize();
// //     // }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         body: Column(
// //           children: [
// //             Text(status + userName),
// //             Row(
// //               children: [
// //                 ElevatedButton(
// //                     onPressed: () {
// //                       signalingClient?.connect(
// //                           "8786BUCW",
// //                           "wss://signalling.vdotok.com:8443/callV1",
// //                           vdotokRef, //referenceID
// //                           vdotokAuth, //AuthorizationToken
// //                           "r-stun1.vdotok.dev",
// //                           3478);
// //                       setState(() {
// //                         userName = " vdtok";
// //                         status = "connecting";
// //                       });
// //                     },
// //                     child: Text(" vdotok")),
// //                 ElevatedButton(
// //                     onPressed: () {
// //                       signalingClient?.connect(
// //                           "8786BUCW",
// //                           "wss://signalling.vdotok.com:8443/callV1",
// //                           vdotokRef, //referenceID
// //                           vdotokAuth, //AuthorizationToken
// //                           "r-stun1.vdotok.dev",
// //                           3478);
// //                       setState(() {
// //                         userName = " vdtok1";
// //                         status = "connecting";
// //                       });
// //                     },
// //                     child: Text(" vdotok1")),
// //                 ElevatedButton(
// //                     onPressed: () {
// //                       signalingClient?.connect(
// //                           "8786BUCW",
// //                           "wss://signalling.vdotok.com:8443/callV1",
// //                           vdotok2Ref, //referenceID
// //                           vdotok2Auth, //AuthorizationToken
// //                           "r-stun1.vdotok.dev",
// //                           3478);
// //                       setState(() {
// //                         userName = " vdtok2";
// //                         status = "connecting";
// //                       });
// //                     },
// //                     child: Text(" vdotok2")),
// //                 ElevatedButton(
// //                     onPressed: () {
// //                       signalingClient?.connect(
// //                           "1RN1RP",
// //                           "wss://q-signalling.vdotok.dev:8443/callV1",
// //                           vdotok3Ref, //referenceID
// //                           vdotok3Auth, //AuthorizationToken
// //                           "r-stun1.vdotok.dev",
// //                           3478);
// //                       setState(() {
// //                         userName = " vdtok3";
// //                         status = "connecting";
// //                       });
// //                     },
// //                     child: Text("vdotok3"))
// //               ],
// //             ),
// //             Container(
// //               width: 100,
// //               height: 100,
// //               child: _localRenderer.srcObject == null
// //                   ? Text("camera")
// //                   : RTCVideoView(_localRenderer, mirror: false),
// //             ),
// //             Expanded(
// //                 child: fullScreenIndex == null
// //                     ? Text("Full Screen")
// //                     : RTCVideoView(
// //                         sessionList.values
// //                             .toList()[fullScreenIndex!]
// //                             .remoteRenderer,
// //                         mirror: false)),
// //             // Row(
// //             //   children: [
// //             //     Container(
// //             //       width: 100,
// //             //       height: 100,
// //             //       child: _localRenderer.srcObject == null
// //             //           ? Text("camera")
// //             //           : RTCVideoView(_localRenderer, mirror: false),
// //             //     ),
// //             //     Container(
// //             //       width: 100,
// //             //       height: 100,
// //             //       child: _remoteRenderer.srcObject == null
// //             //           ? Text("remote")
// //             //           : RTCVideoView(_remoteRenderer, mirror: false),
// //             //     ),
// //             //   ],
// //             // ),
// //             Container(
// //               width: MediaQuery.sizeOf(context).width,
// //               height: 100,
// //               child: ListView.builder(
// //                   scrollDirection: Axis.horizontal,
// //                   padding: const EdgeInsets.all(8),
// //                   itemCount: sessionList.values.length,
// //                   itemBuilder: (BuildContext context, int index) {
// //                     return InkWell(
// //                       onTap: () {
// //                         print("this is on Pressddddd");
// //                         setState(() {
// //                           fullScreenIndex = index;
// //                         });
// //                       },
// //                       child: Container(
// //                         width: 100,
// //                         height: 100,
// //                         child: sessionList.values
// //                                     .toList()[index]
// //                                     .remoteRenderer
// //                                     .srcObject ==
// //                                 null
// //                             ? Text("remote")
// //                             : AbsorbPointer(
// //                                 child: RTCVideoView(
// //                                     sessionList.values
// //                                         .toList()[index]
// //                                         .remoteRenderer,
// //                                     mirror: false),
// //                               ),
// //                       ),
// //                     );
// //                   }),
// //             ),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     print(
// //                         'vdotok---${vdotokRef}--- ${vdotok1Ref} $vdotok2Ref $vdotok3Ref');
// //                     signalingClient?.startCall(
// //                       from: vdotokRef,
// //                       to: [vdotok1Ref, vdotok2Ref, vdotok3Ref],
// //                       mediaType: "video",
// //                       callType: "many_to_many",
// //                       sessionType: "call",
// //                       customData: {
// //                         "calleName": "vdotok",
// //                         "groupName": "",
// //                         "groupAutoCreatedValue": ""
// //                       },
// //                     );
// //                     // signalingClient?.startCall(
// //                     //   vdotokRef,
// //                     //   [vdotok1Ref],
// //                     //   "video",
// //                     //   CAllType.many2many,
// //                     //   "call",
// //                     //   customData: {
// //                     //     "calleName": "vdotok",
// //                     //     "groupName": "",
// //                     //     "groupAutoCreatedValue": ""
// //                     //   },
// //                     // );

// //                     // signalingClient.startCall()
// //                   },
// //                   child: Text("startCall"),
// //                 ),
// //                 ElevatedButton(
// //                   style: ButtonStyle(
// //                       backgroundColor: incommingSession == false
// //                           ? MaterialStatePropertyAll<Color>(Colors.white)
// //                           : MaterialStatePropertyAll<Color>(Colors.green)),
// //                   onPressed: () {
// //                     signalingClient?.accept();
// //                   },
// //                   child: Text("Accept call"),
// //                 ),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     signalingClient?.bye();
// //                   },
// //                   child: Text("endCall"),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'dart:async';

// // import 'package:flutter/services.dart';
// // import 'package:vdotok_stream/vdotok_stream.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatefulWidget {
// //   const MyApp({Key? key}) : super(key: key);

// //   @override
// //   State<MyApp> createState() => _MyAppState();
// // }

// // class _MyAppState extends State<MyApp> {
// //   String _platformVersion = 'Unknown';

// //   @override
// //   void initState() {
// //     super.initState();
// //     initPlatformState();
// //   }

// //   // Platform messages are asynchronous, so we initialize in an async method.
// //   Future<void> initPlatformState() async {
// //     String platformVersion;
// //     // Platform messages may fail, so we use a try/catch PlatformException.
// //     // We also handle the message potentially returning null.
// //     try {
// //       platformVersion =
// //           await VdotokStream.platformVersion ?? 'Unknown platform version';
// //     } on PlatformException {
// //       platformVersion = 'Failed to get platform version.';
// //     }

// //     // If the widget was removed from the tree while the asynchronous platform
// //     // message was in flight, we want to discard the reply rather than calling
// //     // setState to update our non-existent appearance.
// //     if (!mounted) return;

// //     setState(() {
// //       _platformVersion = platformVersion;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Plugin example app'),
// //         ),
// //         body: Center(
// //           child: Text('Running on: $_platformVersion\n'),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:vdotok_stream/vdotok_stream.dart';

// import 'package:web_socket_channel/web_socket_channel.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

// void main() {
//   HttpOverrides.global = MyHttpOverrides();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Vdotok Video',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSwatch(
//             primarySwatch: Colors.grey,
//           ).copyWith(),
//           // accentColor: primaryColor,
//           scaffoldBackgroundColor: Colors.white,
//         ),
//         // onGenerateRoute: Routers.generateRoute,
//         home: Test());
//   }
// }

// class Test extends StatefulWidget {
//   @override
//   _TestState createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   SignalingClient? signalingClient;
//   MediaStream? _localStream;
//   RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
//   RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
//   int? fullScreenIndex;
//   late TextEditingController _controller;
//   late TextEditingController _controllerSecondSession;
//   late TextEditingController _controllerAuth;
//   late TextEditingController _controllerAutherizationToken;
//   String userName = "";
//   String status = "";
//   String vdotokRef = "8786BUCWb04e55cd8e1b05890c2a40ac460faa67"; //bnnn
//   String vdotokAuth = "8a9c39dc89353a5442ed415270692d4d";
// //  hnnn
//   String vdotok1Ref = "8786BUCW447b39026c9bd3dee7c96f8aea863cad";
//   String vdotok1Auth = "bb682b87ad1bcf632d650a3c81d669a4";
//   // dnnn
//   String vdotok2Ref = "8786BUCWfeca4215d2364cda1b4d278b2319d7ee";
//   String vdotok2Auth = "2fff8e9ccb599ea135c6ed7a39edb042";
// // Knnn
//   String vdotok3Ref = "8786BUCW7a22f5b6cfa9b495e57539b4989ae007";
//   String vdotok3Auth = "b5af7e785dbd2f9ac8d2f09aa22b3e7d";

//   String projectID = "8786BUCW";
//   String completeAdd = "wss://signalling.vdotok.com:8443/callV1";

//   Map<String, Session> sessionList = {};
//   bool incommingSession = false;

//   @override
//   void initState() {
//     // TODO: implement initState

//     // initRenderers();
//     _controller = TextEditingController();
//     _controllerSecondSession = TextEditingController();
//     _controllerAuth = TextEditingController();
//     _controllerAutherizationToken = TextEditingController();
//     signalingClient = SignalingClient.instance;
//     _controllerSecondSession.text = vdotokRef;
//     _controllerAutherizationToken.text = vdotokRef;

//     // signalingClient.methodInvoke();
//     super.initState();
//     // initRenderers();

//     signalingClient?.onLocalStream = (stream) {
//       setState(() {
//         _localRenderer = stream;
//       });
//     };
//     signalingClient?.onRegister = (res) {
//       print("on Register $res");
//       setState(() {
//         status = "Connected";
//       });
//     };
//     signalingClient?.onInComingCall = (d) {
//       setState(() {
//         incommingSession = true;
//       });
//     };
//     signalingClient?.onLocalAudioVideoStates = (res) {
//       print("on onLocalAudioVideoStates $res");
//     };
//     signalingClient?.onAddRemoteStream = (sessionMap) {
//       setState(() {
//         sessionList = sessionMap!;
//       });

//       // int indexat =
//       //     sessionList.indexWhere((element) => (element.to == session.to));
//       // if (indexat != -1) {
//       //   setState(() {
//       //     sessionList[indexat].remoteRenderer = session.remoteRenderer;
//       //   });
//       // }
//     };

//     signalingClient?.onCallStateChange =
//         (Map<String, Session>? SessionMap, CallState state) async {
//       print("this is call State $state");

//       switch (state) {
//         case CallState.CallStateNew:
//           break;
//         case CallState.CallSession:
//           {
//             // int indexat = sessionList
//             //     .indexWhere((element) => (element.to == session!.to));
//             // if (indexat == -1) {
//             setState(() {
//               sessionList = SessionMap!;
//             });
//           }

//           break;
//         case CallState.CallStateRinging:
//           {
//             setState(() {
//               incommingSession = true;
//             });
//             // setState(() {
//             //   _session = session;
//             //   mediaType = session!.mediaType!;
//             // });
//             // _callProvider!.callReceive();
//           }
//           break;
//         case CallState.CallStateBye:
//           {
//             if (SessionMap == null) {
//               // sessionList.forEach((element) async {
//               //   await element.remoteRenderer.dispose();
//               // });
//               setState(() {
//                 if (_localRenderer.srcObject != null) {
//                   _localRenderer.srcObject = null;
//                 }
//                 sessionList.clear();
//                 incommingSession = false;
//               });
//             } else {
//               setState(() {
//                 sessionList.remove(SessionMap.keys.first);
//               });
//             }
//           }
//           break;
//         case CallState.ParticipantLeft:
//           {
//             if (SessionMap != null) {
//               setState(() {
//                 sessionList.remove(SessionMap.keys.first);
//               });
//             }
//             // if (session == null) {
//             // } else {
//             //   int index = sessionList
//             //       .indexWhere((element) => element.to == session!.to);
//             //   // print("this is index $index");
//             //   // await sessionList[index].remoteRenderer.dispose();
//             //   setState(() {
//             //     sessionList.removeAt(index);
//             //   });
//             // }
//           }
//           break;
//         case CallState.CallStateInvite:
//           // _callProvider!.callDial();
//           break;
//         case CallState.CallStateConnected:
//           {
//             // _callticker?.cancel();
//             // _time = DateTime.now();
//             // print(
//             //     "this is current time......... $_time......this is calll start time");
//             // _ticker = Timer.periodic(Duration(seconds: 1), (_) => _getTimer());
//             // print("ticker is $_ticker");

//             // _callProvider!.callStart();
//             // setState(() {
//             //   _remoteRenderer = session!.remoteRenderer;
//             // });
//           }

//           break;
//       }
//     };

//     // signalingClient?.onRemoteStream = (stream, d) {
//     //   print("this is local stream ${stream}");
//     //   if (_localRenderer.srcObject == null) {
//     //     setState(() {
//     //       _localRenderer.srcObject = stream;
//     //     });
//     //   } else {
//     //     setState(() {
//     //       _screenShareRenderer.srcObject = stream;
//     //     });
//     //   }
//     // };
//     // signalingClient.getPermissions();
//   }

//   Future<void> initRenderers() async {
//     // if (type == "screen") {
//     await _remoteRenderer.initialize();
//     // } else {
//     await _localRenderer.initialize();
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             Text(status + userName),
//             Row(
//               children: [
//                 ElevatedButton(
//                     onPressed: () {
//                       signalingClient?.connect(
//                           projectID,
//                           completeAdd,
//                           vdotokRef, //referenceID
//                           vdotokAuth, //AuthorizationToken
//                           "r-stun1.vdotok.dev",
//                           3478);
//                       setState(() {
//                         userName = " vdtok";
//                         status = "connecting";
//                       });
//                     },
//                     child: Text(" vdotok")),
//                 ElevatedButton(
//                     onPressed: () {
//                       signalingClient?.connect(
//                           projectID,
//                           completeAdd,
//                           vdotok1Ref, //referenceID
//                           vdotok1Auth, //AuthorizationToken
//                           "r-stun1.vdotok.dev",
//                           3478);
//                       setState(() {
//                         userName = " vdtok1";
//                         status = "connecting";
//                       });
//                     },
//                     child: Text(" vdotok1")),
//                 ElevatedButton(
//                     onPressed: () {
//                       signalingClient?.connect(
//                           projectID,
//                           completeAdd,
//                           vdotok2Ref, //referenceID
//                           vdotok2Auth, //AuthorizationToken
//                           "r-stun1.vdotok.dev",
//                           3478);
//                       setState(() {
//                         userName = " vdtok2";
//                         status = "connecting";
//                       });
//                     },
//                     child: Text(" vdotok2")),
//                 ElevatedButton(
//                     onPressed: () {
//                       signalingClient?.connect(
//                           projectID,
//                           completeAdd,
//                           vdotok3Ref, //referenceID
//                           vdotok3Auth, //AuthorizationToken
//                           "r-stun1.vdotok.dev",
//                           3478);
//                       setState(() {
//                         userName = " vdtok3";
//                         status = "connecting";
//                       });
//                     },
//                     child: Text("vdotok3"))
//               ],
//             ),
//             Container(
//               width: 100,
//               height: 100,
//               child: _localRenderer.srcObject == null
//                   ? Text("camera")
//                   : RTCVideoView(_localRenderer, mirror: false),
//             ),
//             Expanded(
//                 child: fullScreenIndex == null
//                     ? Text("Full Screen")
//                     : RTCVideoView(
//                         sessionList.values
//                             .toList()[fullScreenIndex!]
//                             .remoteRenderer,
//                         mirror: false)),
//             // Row(
//             //   children: [
//             //     Container(
//             //       width: 100,
//             //       height: 100,
//             //       child: _localRenderer.srcObject == null
//             //           ? Text("camera")
//             //           : RTCVideoView(_localRenderer, mirror: false),
//             //     ),
//             //     Container(
//             //       width: 100,
//             //       height: 100,
//             //       child: _remoteRenderer.srcObject == null
//             //           ? Text("remote")
//             //           : RTCVideoView(_remoteRenderer, mirror: false),
//             //     ),
//             //   ],
//             // ),
//             Container(
//               width: MediaQuery.sizeOf(context).width,
//               height: 100,
//               child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.all(8),
//                   itemCount: sessionList.values.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return InkWell(
//                       onTap: () {
//                         print("this is on Pressddddd");
//                         setState(() {
//                           fullScreenIndex = index;
//                         });
//                       },
//                       child: Container(
//                         width: 100,
//                         height: 100,
//                         child: sessionList.values
//                                     .toList()[index]
//                                     .remoteRenderer
//                                     .srcObject ==
//                                 null
//                             ? Text("remote")
//                             : AbsorbPointer(
//                                 child: RTCVideoView(
//                                     sessionList.values
//                                         .toList()[index]
//                                         .remoteRenderer,
//                                     mirror: false),
//                               ),
//                       ),
//                     );
//                   }),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     signalingClient?.startCall(
//                       from: vdotokRef,
//                       to: [vdotok1Ref, vdotok2Ref, vdotok3Ref],
//                       mediaType: "video",
//                       callType: CAllType.many2many,
//                       sessionType: "call",
//                       customData: {
//                         "calleName": "vdotok",
//                         "groupName": "",
//                         "groupAutoCreatedValue": ""
//                       },
//                     );
//                     // signalingClient?.startCall(
//                     //   vdotokRef,
//                     //   [vdotok1Ref],
//                     //   "video",
//                     //   CAllType.many2many,
//                     //   "call",
//                     //   customData: {
//                     //     "calleName": "vdotok",
//                     //     "groupName": "",
//                     //     "groupAutoCreatedValue": ""
//                     //   },
//                     // );

//                     // signalingClient.startCall()
//                   },
//                   child: Text("startCall"),
//                 ),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                       backgroundColor: incommingSession == false
//                           ? MaterialStatePropertyAll<Color>(Colors.white)
//                           : MaterialStatePropertyAll<Color>(Colors.green)),
//                   onPressed: () {
//                     signalingClient?.accept();
//                   },
//                   child: Text("Accept call"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     signalingClient?.bye();
//                   },
//                   child: Text("endCall"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
