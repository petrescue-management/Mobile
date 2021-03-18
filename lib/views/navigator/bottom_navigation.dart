import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/src/style.dart';

// ignore: must_be_immutable
class BottomNaviBar extends StatefulWidget {
  List<Widget> pages;
  List<BottomNavigationBarItem> bottomNaviItems;

  BottomNaviBar({
    this.pages,
    this.bottomNaviItems,
  });

  @override
  _BottomNaviBarState createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _bottomNaviBar(int selectedIndex) {
    return BottomNavigationBar(
      selectedItemColor: color2,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (int index) => setState(() => _selectedIndex = index),
      currentIndex: selectedIndex,
      items: widget.bottomNaviItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        bottomNavigationBar: _bottomNaviBar(_selectedIndex),
        body: Stack(
          children: [
            Container(
              child: PageStorage(
                child: widget.pages[_selectedIndex],
                bucket: bucket,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
