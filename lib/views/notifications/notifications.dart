import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/src/asset.dart';

// ignore: must_be_immutable
class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key}) : super(key: key);

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
          'THÔNG BÁO',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
            height: MediaQuery.of(context).size.height * 0.87,
            child: SizedBox(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
