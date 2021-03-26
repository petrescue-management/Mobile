import 'package:flutter/material.dart';
// import 'package:pet_rescue_mobile/views/progress/progress_card.dart';
// import 'package:pet_rescue_mobile/views/notifications/notifications_badge.dart';

// ignore: must_be_immutable
class NotificationsPage extends StatefulWidget {

  NotificationsPage({Key key})
      : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // NotificationBadge(totalNotifications: widget.totalNotifications)
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.87,
        child: SizedBox(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                // NotificationBadge(totalNotifications: widget.totalNotifications)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
