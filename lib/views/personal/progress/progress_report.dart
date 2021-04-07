import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/personal/progress/progress_card.dart';

class ProgressReportPage extends StatefulWidget {
  const ProgressReportPage({Key key}) : super(key: key);

  @override
  _ProgressReportPageState createState() => _ProgressReportPageState();
}

class _ProgressReportPageState extends State<ProgressReportPage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 35,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: buildTabBar(),
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
            buildTabBody(),
          ],
        ),
      ),
    );
  }

  Widget buildTabBar() {
    return TabBar(
      labelColor: Colors.black,
      labelStyle: TextStyle(
        fontSize: 16,
        fontFamily: 'Philosopher',
        fontWeight: FontWeight.bold,
      ),
      indicatorColor: color2,
      tabs: <Widget>[
        Tab(
          text: 'Cứu hộ',
        ),
        Tab(text: 'Nhận nuôi'),
      ],
    );
  }

  Widget buildTabBody() {
    return TabBarView(children: <Widget>[
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
    ]);
  }
}
