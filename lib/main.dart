import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:splashscreen/splashscreen.dart';

import 'views/login_page.dart';

void main() => runApp(
  new MaterialApp(
    home: new MyApp(),
  )
);

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 7,
      navigateAfterSeconds: LoginPage(),
      image: new Image.asset(
        app_logo,
      ),
      photoSize: 120,
      backgroundColor: common,
      loaderColor: Colors.red,
    );
  }
}

// class _MyApp extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Rescue Them',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginPage(),
//     );
//   }
// }