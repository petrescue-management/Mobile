import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/views/navigator/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/resource/location/app_data.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => AppData(),
        child: MaterialApp(
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => MyApp(),
          },
          // home: new MyApp(),
        ),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  final _repo = Repository();

  // final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');

        final snackBar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () => null,
          ),
        );

        Scaffold.of(context).showSnackBar(snackBar);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: FutureBuilder<FirebaseUser>(
          future: _repo.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasError) {
              return loading(context);
            } else if (snapshot.data == null) {
              return BottomNaviBar(
                bottomNaviItems: isNotLoggedInBottomNavItems,
                pages: isNotLoggedInPages,
              );
            } else {
              _repo.getUserDetails();
              return BottomNaviBar(
                bottomNaviItems: isLoggedInBottomNavItems,
                pages: isLoggedInPages,
              );
            }
          }),
    );
  }

  Widget loading(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
