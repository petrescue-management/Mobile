import 'package:commons/commons.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';

// ignore: must_be_immutable
class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  ScrollController scrollController = ScrollController();

  Query _ref;

  String userId;

  @override
  void initState() {
    super.initState();
    getRef();
  }

  getRef() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Query reference = FirebaseDatabase.instance
        .reference()
        .child('authUser')
        .child('${sharedPreferences.getString('userId')}')
        .child('Notification')
        .orderByChild('date');

    setState(() {
      _ref = reference;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(background),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            alignment: Alignment.topCenter,
            child: Text(
              'THÔNG BÁO',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _ref == null
              ? loading(context)
              : Container(
                  padding: EdgeInsets.only(top: 65),
                  child: FirebaseAnimatedList(
                    controller: scrollController,
                    query: _ref,
                    sort: (a, b) {
                      return b.value['date'].compareTo(a.value['date']);
                    },
                    itemBuilder: (context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      if (_ref == null || snapshot == null) {
                        return loading(context);
                      } else {
                        String notiKey = snapshot.key;
                        Map notification = snapshot.value;
                        print(snapshot.value);
                        return _buildItem(notification, notiKey);
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }

  formatDateTime(String date) {
    DateTime tmp = DateTime.parse(date);
    String tmpDay = (tmp.day < 10 ? '0${tmp.day}' : '${tmp.day}');
    String tmpMonth = (tmp.month < 10 ? '0${tmp.month}' : '${tmp.month}');
    String tmpMinute = (tmp.minute < 10 ? '0${tmp.minute}' : '${tmp.minute}');
    String result = '$tmpDay/$tmpMonth/${tmp.year}  ${tmp.hour}:$tmpMinute';
    return result;
  }

  getNotificationTypeIcon(int type) {
    if (type == 1) {
      return adopt_logo;
    } else if (type == 2) {
      return rescue_logo;
    } else {
      return '';
    }
  }

  Widget _buildItem(Map notification, String notificationKey) {
    String typeIcon = getNotificationTypeIcon(notification['type']);
    var notiDate = formatDateTime(notification['date']);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: backgroundColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: mainColor,
                  width: 1.5,
                ),
                image: DecorationImage(
                  image: AssetImage(typeIcon),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['body'],
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        notiDate,
                        style: TextStyle(
                          fontSize: 13,
                          color: mainColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
