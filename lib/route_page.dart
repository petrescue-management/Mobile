import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/views/home_page.dart';
import 'package:pet_rescue_mobile/views/login_page.dart';

class RoutePage extends StatefulWidget {
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    print('initState');

  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn == true ? HomePage() : LoginPage();
  }
}

