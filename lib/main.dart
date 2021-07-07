import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vdotok_stream/vdotok_stream.dart';
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        debugShowCheckedModeBanner: false,
        title: 'Vdotok Video',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.grey,
            ).copyWith(),
            accentColor: primaryColor,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: Colors.white,
            textTheme: TextTheme(
              bodyText1: TextStyle(color: secondaryColor),
              bodyText2: TextStyle(color: secondaryColor), //Text
            )),
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

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  SignalingClient signalingClient;
  @override
  void initState() {
    // TODO: implement initState

    signalingClient = SignalingClient.instance;
    // signalingClient.methodInvoke();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: signalingClient.numberStream(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData)
                    return Text(snapshot.data.toString());
                  else if (snapshot.hasError)
                    return Text("no data found");
                  else
                    return Text("no data found");
                }),
            RaisedButton(
              onPressed: () {
                // signalingClient.handleLocationChanges();
              },
              child: Text("invoke method"),
            )
          ],
        ),
      ),
    );
  }
}
