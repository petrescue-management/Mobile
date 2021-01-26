import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/views/profile/profile_menu.dart';
import 'package:pet_rescue_mobile/views/profile/profile_pic.dart';
import 'package:pet_rescue_mobile/repository/sign_in.dart';
import 'package:pet_rescue_mobile/views/navigator/bottomnav_nologin.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          child: Column(
        children: [
          ProfilePic(),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProfileMenu(
                    text: 'My Account',
                    icon: Icons.perm_identity,
                    press: () {}),
                ProfileMenu(text: 'My Pet', icon: Icons.pets, press: () {}),
                ProfileMenu(
                    text: 'Setting', icon: Icons.settings, press: () {}),
                ProfileMenu(
                    text: 'Log Out',
                    icon: Icons.logout,
                    press: () {
                      signOutGoogle().then((_) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotYetLoginBottomNavBar()));
                      });
                    }),
              ],
            ),
          )
        ],
      )),
    ));
  }
}
