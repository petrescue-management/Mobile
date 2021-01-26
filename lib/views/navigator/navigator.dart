import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/src/style.dart';
import '../home_page.dart';
import '../profile/profile.dart';
import '../progress/progress_report.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> pages = [
    HomePage(key: PageStorageKey('HomePage')),
    ProgressReportPage(key: PageStorageKey('ProgressReportPage')),
    ProfilePage(key: PageStorageKey('ProfilePage')),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget _bottomNavBar(int selectedIndex) => BottomNavigationBar(
        selectedItemColor: color2,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: selectedIndex,
        items: bottomItems,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomNavBar(_selectedIndex),
        body: Stack(children: [
          Container(
            child: PageStorage(
              child: pages[_selectedIndex],
              bucket: bucket,
            ),
          ),
        ]));
  }

  final bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.article),
      label: 'Progress Report',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.perm_identity),
      label: 'Profile',
    ),
  ];
}
