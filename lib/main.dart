import 'package:commons/commons.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/resource/location/app_data.dart';
import 'package:pet_rescue_mobile/models/push_notification.dart';

import 'package:pet_rescue_mobile/views/home_page.dart';
import 'package:pet_rescue_mobile/views/navigator/bottom_navigation.dart';
import 'package:pet_rescue_mobile/views/notifications/notifications.dart';
import 'package:pet_rescue_mobile/views/personal/personal.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => AppData(),
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Philosopher'),
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => MyApp(),
          },
        ),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  final _repo = Repository();

  FirebaseMessaging _fcm = FirebaseMessaging();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  DatabaseReference _dbReference;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    PushNotification _notificationInfo;

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSetttings =
        InitializationSettings(initializationSettingsAndroid, null);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    // Used to get the current FCM token
    _fcm.getToken().then((token) {
      print('Token: $token');
    }).catchError((e) {
      print(e);
    });

    // Retrieve notification
    retrieveNotification(_notificationInfo);
  }

  Future onSelectNotification(String payload) async {}

  showNotification(String title, String body) async {
    var android = AndroidNotificationDetails(
      'id',
      'channel ',
      'description',
      priority: Priority.High,
      importance: Importance.Max,
    );
    var platform = new NotificationDetails(android, null);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platform,
      payload: 'Welcome to the Local Notification demo',
    );
  }

  retrieveNotification(PushNotification _notificationInfo) {
    Future.delayed(Duration(seconds: 1), () {
      _fcm.configure(
        // app in the foreground
        onMessage: (Map<String, dynamic> message) async {
          print('onMessage: $message');

          PushNotification notification = PushNotification.fromJson(message);

          setState(() {
            _notificationInfo = notification;
          });

          showNotification(_notificationInfo.title, _notificationInfo.body);

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          _dbReference = FirebaseDatabase.instance
              .reference()
              .child('authUser')
              .child('${sharedPreferences.getString('userId')}');

          saveOrUpdateNotifications(
              _notificationInfo.title, _notificationInfo.body, _dbReference);
        },

        // app in the background
        onResume: (Map<String, dynamic> message) async {
          print('onResume: $message');
        },

        // app terminated
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch: $message');
        },
      );
    });
  }

  saveOrUpdateNotifications(String title, String body, DatabaseReference _ref) {
    Map<String, dynamic> noti = {
      'title': title,
      'body': body,
      'datetime': DateTime.now().toString(),
    };

    _ref.child('1').set(noti);
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
                bottomNaviItems: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.notifications), label: 'Notifications'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.perm_identity), label: 'Profile'),
                ],
                pages: [
                  HomePage(key: PageStorageKey('HomePage')),
                  NotificationsPage(key: PageStorageKey('NotificationsPage')),
                  PersonalPage(key: PageStorageKey('PersonalPage')),
                ],
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
