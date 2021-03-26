import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/views/home_page.dart';
import 'package:pet_rescue_mobile/views/login/login_request.dart';

final List<String> imgList = [
  //'https://thecatandthedog.com/wp-content/uploads/2020/11/petcare-large.jpg',
  'https://img.etimg.com/thumb/msid-76546023,width-640,resizemode-4,imgsize-918765/pet-care-tips.jpg',
  'https://cdn.corporate.walmart.com/dims4/WMT/6cb59be/2147483647/strip/true/crop/2000x1304+0+13/resize/920x600!/quality/90/?url=https%3A%2F%2Fcdn.corporate.walmart.com%2Fd7%2F66%2Fad4a88bd4a09bfffe44b1f604ecf%2Fwalmart-pet-care-lead-image.jpg',
];

final String mapKey = 'AIzaSyAZ4pja68qoa62hCzFdlmAu30iAb_CgmTk';

final List<Widget> isNotLoggedInPages = [
  HomePage(key: PageStorageKey('HomePage')),
  LoginRequest(key: PageStorageKey('LoginRequest')),
];

final isNotLoggedInBottomNavItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.login),
    label: 'Login Request',
  ),
];
