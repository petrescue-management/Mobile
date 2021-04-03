import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/src/asset.dart';

import 'package:pet_rescue_mobile/views/personal/progress/progress_card.dart';
import 'package:pet_rescue_mobile/main.dart';

class ProgressReportPage extends StatefulWidget {
  const ProgressReportPage({Key key}) : super(key: key);

  @override
  _ProgressReportPageState createState() => _ProgressReportPageState();
}

class _ProgressReportPageState extends State<ProgressReportPage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'YÊU CẦU CỦA TÔI',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                image: AssetImage(bgxp),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: SizedBox(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    ProgressCard(),
                    ProgressCard(),
                    ProgressCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
