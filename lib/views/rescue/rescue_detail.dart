import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

// ignore: must_be_immutable
class RescueDetail extends StatelessWidget {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yêu cầu cứu hộ của bạn',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 35,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
      ),
    );
  }
}
