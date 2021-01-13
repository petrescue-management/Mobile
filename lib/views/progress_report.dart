import 'package:flutter/material.dart';

class ProgressReportPage extends StatefulWidget {
  const ProgressReportPage({Key key}) : super(key: key);

  @override
  _ProgressReportPageState createState() => _ProgressReportPageState();
}

class _ProgressReportPageState extends State<ProgressReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.green[100]),
    );
  }
}