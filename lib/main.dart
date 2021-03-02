import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:pet_rescue_mobile/src/asset.dart';
// import 'package:pet_rescue_mobile/src/style.dart';
// import 'package:splashscreen/splashscreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/views/navigator/navigator.dart';
import 'package:pet_rescue_mobile/views/navigator/bottomnav_nologin.dart';

void main() => runApp(new MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => MyApp(),
      },
      // home: new MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  final _repo = Repository();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return new SplashScreen(
  //     seconds: 3,
  //     navigateAfterSeconds: FutureBuilder<FirebaseUser>(
  //         future: _repo.getCurrentUser(),
  //         builder:
  //             (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
  //           if (snapshot.hasError)
  //             return SplashScreen();
  //           else if (snapshot.data == null)
  //             return NotYetLoginBottomNavBar();
  //           else
  //             return BottomNavBar();
  //         }),
  //     image: new Image.asset(
  //       app_logo_circle,
  //     ),
  //     photoSize: 150,
  //     backgroundColor: common,
  //     loaderColor: Colors.red,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: _repo.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.data == null)
            return NotYetLoginBottomNavBar();
          else
            return BottomNavBar();
        });
  }
}
