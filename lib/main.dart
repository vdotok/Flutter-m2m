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

