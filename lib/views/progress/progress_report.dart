import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
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
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.wysiwyg),
            color: Colors.black,
            onPressed: () {
              warningDialog(
                context,
                "Chưa có yêu cầu nào hoàn thành!",
                title: "",
              );
            },
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: SizedBox(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                ProgressCard(),
                ProgressCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
