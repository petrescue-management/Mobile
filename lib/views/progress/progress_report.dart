import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/views/progress/progress_card.dart';

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
          'Yêu cầu của tôi',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 35,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Container(
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
      ),
    );
  }
}
