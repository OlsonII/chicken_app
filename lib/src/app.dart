import 'package:chicken_app/src/presentation/home_page.dart';
import 'package:chicken_app/src/presentation/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

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
        fontFamily: 'ProductSans'
      ),
      //home: SplashScreen(),
      initialRoute: '/home',
      routes: {
        '/splash'       : (BuildContext context) => SplashScreen(),
        '/home'         : (BuildContext context) => HomePage(),
      },
    );
  }
}