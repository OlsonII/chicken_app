import 'package:chicken_app/src/pages/driver_profile_page.dart';
import 'package:chicken_app/src/pages/home_page.dart';
import 'package:chicken_app/src/pages/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'bloc/driver_bloc.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(254, 206, 46,  1));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return MaterialApp(
      title: 'Chicken App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: SplashScreen(),
      initialRoute: '/home',
      routes: {
        '/home' : (BuildContext context) => HomePage(),
        '/splash' : (BuildContext context) => SplashScreen(),
        '/profile_page' : (BuildContext context) => DriverProfilePage()
      },
    );
  }
}