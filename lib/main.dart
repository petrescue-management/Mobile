import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_rescue_mobile/presenter/sign_in.dart';

import 'package:splashscreen/splashscreen.dart';

import 'views/login_page.dart';

import 'package:pet_rescue_mobile/navigator.dart';
// import 'package:pet_rescue_mobile/views/home_page.dart';
// import 'package:pet_rescue_mobile/views/rescue.dart';

void main() => runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: FutureBuilder<FirebaseUser>(
          future: getCurrentUser(),
          builder:
              (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
            print(getCurrentUser().then((value) => print(value.uid)));
            if (snapshot.hasError)
              return SplashScreen();
            else if (snapshot.data == null)
              return LoginPage();
            else
              return BottomNavBar();
          }),
      image: new Image.asset(
        app_logo,
      ),
      photoSize: 150,
      backgroundColor: common,
      loaderColor: Colors.red,
    );
  }
}

// class _MyApp extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Rescue Them',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: BottomNavBar(),
//     );
//   }
// }
