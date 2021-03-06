import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vdotok_stream_example/src/core/providers/call_provider.dart';
import 'package:vdotok_stream_example/src/core/providers/contact_provider.dart';
import 'package:vdotok_stream_example/src/core/providers/groupListProvider.dart';
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
  @override
  void initState() {
    super.initState();

    rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

//  netConnectivityCallBack = (mesg) {

// if (mesg == "Connected") {

// setState(() {

// isConnected = true;

// });

// showSnackbar("Internet Connected", whiteColor, Colors.green, false);

// } else {

// print("no internet connection");

// setState(() {

// isConnected = false;

// });

// showSnackbar("No Internet Connection", whiteColor, primaryColor, true);

// }

// };

//checkStatus();

//checkConnectivity();
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
              return HomeIndex();
            } else
              return SignInScreen();
          },
        ),
      ),
    );
  }
}

// class Test extends StatefulWidget {
//   @override
//   _TestState createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   SignalingClient signalingClient;
//   @override
//   void initState() {
//     // TODO: implement initState

//     signalingClient = SignalingClient.instance;
//     // signalingClient.methodInvoke();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             StreamBuilder(
//                 stream: signalingClient.numberStream(),
//                 builder: (BuildContext context, snapshot) {
//                   if (snapshot.hasData)
//                     return Text(snapshot.data.toString());
//                   else if (snapshot.hasError)
//                     return Text("no data found");
//                   else
//                     return Text("no data found");
//                 }),
//             RaisedButton(
//               onPressed: () {
//                 // signalingClient.handleLocationChanges();
//               },
//               child: Text("invoke method"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
