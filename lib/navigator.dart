import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'views/home_page.dart';
import 'views/profile.dart';
import 'views/progress_report.dart';

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
      title: new Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.article),
      title: new Text('Progress Report'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.perm_identity),
      title: new Text('Profile'),
    ),
  ];
}
