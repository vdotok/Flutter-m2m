import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vdotok_stream/vdotok_stream.dart';
import 'package:vdotok_stream_example/src/core/models/GroupListModel.dart';
import 'package:vdotok_stream_example/src/core/providers/call_provider.dart';
import 'package:vdotok_stream_example/src/core/providers/contact_provider.dart';
import 'package:vdotok_stream_example/src/core/providers/groupListProvider.dart';
import 'src/core/config/config.dart';
import 'src/core/models/GroupModel.dart';
import 'src/core/providers/auth.dart';
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
void deactivate(){
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
        home: 
        // GestureDetector(
        //      onTap: () {
        //   setState(() {
        //     _desc = 'tap';
        //     print("$_desc");
        //   });
        // },
        // onDoubleTap: () {
        //   setState(() {
        //     _desc = 'double tap';
        //      print("$_desc");
        //   });
        // },
        // onVerticalDragStart: (DragStartDetails details) {
        //   setState(() {
        //     _desc = 'drag start';
        //      print("$_desc");
        //   });
        // },
        // onVerticalDragUpdate: (DragUpdateDetails details) {
        //   setState(() {
        //     _desc = 'drag update';
        //      print("$_desc");
        //   });
        // },
        // onVerticalDragEnd: (DragEndDetails details) {
        //   setState(() {
        //     _desc = 'drag end';
        //      print("$_desc");
        //   });
        // },
        // onHorizontalDragStart: (DragStartDetails details) {
        //   setState(() {
        //     _desc = 'drag start';
        //      print("$_desc");
        //   });
        // },
        // onHorizontalDragUpdate: (DragUpdateDetails details) {
        //   setState(() {
        //     _desc = 'drag update';
        //      print("$_desc");
        //   });
        // },
        // onHorizontalDragEnd: (DragEndDetails details) {
        //   setState(() {
        //     _desc = 'drag end';
        //      print("$_desc");
        //   });
        // },
        //   child: 
          Consumer<AuthProvider>(
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

late AuthProvider _auth;
late GroupListProvider _groupListProvider;
var registerRes;
var customData;
GroupListModel? groupList;
GroupModel? to;
RTCVideoRenderer localRenderer = new RTCVideoRenderer();
RTCVideoRenderer remoteRenderer1 = new RTCVideoRenderer();
RTCVideoRenderer remoteRenderer2 = new RTCVideoRenderer();
RTCVideoRenderer remoteRenderer3 = new RTCVideoRenderer();
RTCVideoRenderer remoteRenderer4 = new RTCVideoRenderer();

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  SignalingClient? signalingClient;
  @override
  void initState() {
    // TODO: implement initState

    signalingClient = SignalingClient.instance;
    _auth = Provider.of<AuthProvider>(context, listen: false);
    _groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    _groupListProvider.getGroupList(_auth.getUser.auth_token);
    // initRenderers();
    signalingClient!.onConnect = (res) {
      print("i am here in onconnect functiono $res");

      if (res == "connected") {
        // sockett = true;
        // isConnected = true;
        // print("this is before socket iffff111 $sockett");
      }

      signalingClient!.register(_auth.getUser.toJson(), project_id);
    };
    signalingClient!.onRegister = (res) {
      print("here in register $res");
      setState(() {
        registerRes = res;
      });
    };

    signalingClient!.onRemoteStream = (stream, refid) async {
      print(
          "onremotestreammm $stream ..... and this is refid $refid......${remoteRenderer1.srcObject}...${remoteRenderer2.srcObject}...${remoteRenderer3.srcObject}");

      setState(() {
        if (remoteRenderer1.srcObject == null) {
          remoteRenderer1 = new RTCVideoRenderer();
          remoteRenderer1.initialize().then((value) {
            remoteRenderer1.srcObject = stream;
            print("this is remoterendere 1st ${remoteRenderer1.srcObject}");
          }
              //  print(value) ;

              ).catchError((onError) {
            print("this is error on initialization of 1st $onError");
          });

          // print("this is remoterendere ${remoteRenderer1.srcObject}");
        } else if (remoteRenderer2.srcObject == null) {
          remoteRenderer2 = new RTCVideoRenderer();
          remoteRenderer2.initialize().then((value) {
            remoteRenderer2.srcObject = stream;
            print("this is remoterendere 2nd ${remoteRenderer2.srcObject}");
          }).catchError((onError) {
            print("this is error on initialization of 2nd $onError");
          });
        } else {
          remoteRenderer3 = new RTCVideoRenderer();
          remoteRenderer3.initialize().then((value) {
            remoteRenderer3.srcObject = stream;
            print("this is remoterendere 3rd ${remoteRenderer3.srcObject}");
          }).catchError((onError) {
            print("this is error on initialization of 3rd $onError");
          });
        }
        print(
            "these are renderes ${remoteRenderer1.srcObject}..${remoteRenderer2.srcObject}..${remoteRenderer3.srcObject}");
      });
    };

    signalingClient!.onCallHungUpByUser = (isLocal) {
      setState(() {
        disposeAllRenderer();
      });
    };
    super.initState();
  }

  @override
  deactivate() {
    super.deactivate();
    print("this is deactivate");
    remoteRenderer1.dispose();
    remoteRenderer2.dispose();
    remoteRenderer3.dispose();
  }

  disposeAllRenderer() async {
    setState(() {
      remoteRenderer1.srcObject = null;
      remoteRenderer1.dispose();
      remoteRenderer2.srcObject = null;
      remoteRenderer2.dispose();
      remoteRenderer3.srcObject = null;

      remoteRenderer3.dispose();
    });
  }

  initRenderers() async {
    print("this is localRenderer $localRenderer");
    await localRenderer
        .initialize()
        .then((value) => null)
        .catchError((onError) {
      print("this is error on initialize $onError");
    });
    print("after initialixxation");
    await remoteRenderer1
        .initialize()
        .then((value) => print("this is value of 1st "))
        .catchError((onError) {
      print("this is error on initialization of 1st $onError");
    });
    await remoteRenderer2
        .initialize()
        .then((value) => print("this is value of second "))
        .catchError((onError) {
      print("this is error on initialization of second $onError");
    });
    await remoteRenderer3
        .initialize()
        .then((value) => print("this is value of third "))
        .catchError((onError) {
      print("this is error on initialization of third $onError");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupListProvider>(
        builder: (context, groupProvider, child) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 10,
                ),
                (remoteRenderer1.srcObject == null)
                    ? Container()
                    : Expanded(
                        child: Container(
                        height: 100,
                        width: 100,
                        child: RTCVideoView(remoteRenderer1,
                            // key: forsmallView,
                            mirror: false,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover),
                      )
                        //  child: Container(height: 100, width: 100, color: Colors.red),
                        ),
                SizedBox(
                  width: 10,
                ),
                (remoteRenderer2.srcObject == null)
                    ? Container()
                    : Expanded(
                        child: Container(
                        height: 100,
                        width: 100,
                        child: RTCVideoView(remoteRenderer2,
                            // key: forsmallView,
                            mirror: false,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover),
                      )
                        // child: Container(
                        //     height: 100, width: 100, color: Colors.purpleAccent),
                        ),
                SizedBox(
                  width: 10,
                ),
                (remoteRenderer3.srcObject == null)
                    ? Container()
                    : Expanded(
                        child: Container(
                        height: 100,
                        width: 100,
                        child: RTCVideoView(remoteRenderer3,
                            // key: forsmallView,
                            mirror: false,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover),
                      )
                        // child:
                        //     Container(height: 100, width: 100, color: Colors.brown),
                        ),
                SizedBox(
                  width: 10,
                ),
                // Expanded(
                //   child: Container(
                //       height: 100, width: 100, color: Colors.yellowAccent),
                // ),
                // SizedBox(
                //   width: 10,
                // ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                signalingClient!.connect(project_id, _auth.completeAddress);
              },
              child: Text("Connect"),
            ),
            // RaisedButton(
            //   onPressed: () {},
            //   child: Text("Register"),
            // ),
            ElevatedButton(
              onPressed: () {
                customData = {
                  "calleName": "",
                  "groupName": "testingGroup",
                  "groupAutoCreatedValue": ""
                };
                List<String> groupRefIDS = [];
                to = groupProvider.groupList.groups![0];
                //to = "testingGroup";
                to!.participants.forEach((element) {
                  if (_auth.getUser.ref_id != element!.ref_id)
                    groupRefIDS.add(element.ref_id.toString());
                });
                signalingClient!.startCall(
                    customData: customData,
                    from: _auth.getUser.ref_id,
                    to: groupRefIDS,
                    mcToken: registerRes["mcToken"],
                    meidaType: "video",
                    callType: "many_to_many",
                    sessionType: "call");
              },
              child: Text("StartCall"),
            )
          ],
        ),
      );
    });
  }
}


// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeService();
//   runApp(const MyApp());
// }

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,

//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,

//       // this will be executed when app is in foreground in separated isolate
//       onForeground: onStart,

//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
//   service.startService();
// }

// // to ensure this is executed
// // run app from xcode, then from xcode menu, select Simulate Background Fetch
// bool onIosBackground(ServiceInstance service) {
//   WidgetsFlutterBinding.ensureInitialized();
//   print('FLUTTER BACKGROUND FETCH');

//   return true;
// }

// void onStart(ServiceInstance service) async {

//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();

//   // For flutter prior to version 3.0.0
//   // We have to register the plugin manually
  

//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.setString("hello", "world");

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   // bring to foreground
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     final hello = preferences.getString("hello");
//     print(hello);

//     if (service is AndroidServiceInstance) {
//       service.setForegroundNotificationInfo(
//         title: "My App Service",
//         content: "Updated at ${DateTime.now()}",
//       );
//     }

//     /// you can see this log in logcat
//     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

//     // test using external plugin
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     }

//     if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }

//     service.invoke(
//       'update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String text = "Stop Service";
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Service App'),
//         ),
//         body: Column(
//           children: [
//             StreamBuilder<Map<String, dynamic>?>(
//               stream: FlutterBackgroundService().on('update'),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 final data = snapshot.data!;
//                 String? device = data["device"];
//                 DateTime? date = DateTime.tryParse(data["current_date"]);
//                 return Column(
//                   children: [
//                     Text(device ?? 'Unknown'),
//                     Text(date.toString()),
//                   ],
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Foreground Mode"),
//               onPressed: () {
//                 FlutterBackgroundService().invoke("setAsForeground");
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Background Mode"),
//               onPressed: () {
//                 FlutterBackgroundService().invoke("setAsBackground");
//               },
//             ),
//             ElevatedButton(
//               child: Text(text),
//               onPressed: () async {
//                 final service = FlutterBackgroundService();
//                 var isRunning = await service.isRunning();
//                 if (isRunning) {
//                   service.invoke("stopService");
//                 } else {
//                   service.startService();
//                 }

//                 if (!isRunning) {
//                   text = 'Stop Service';
//                 } else {
//                   text = 'Start Service';
//                 }
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {},
//           child: const Icon(Icons.play_arrow),
//         ),
//       ),
//     );
//   }
// }