import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
import 'package:pet_rescue_mobile/views/profile/profile_menu.dart';
import 'package:pet_rescue_mobile/views/profile/profile_pic.dart';
import 'package:pet_rescue_mobile/repo/account/sign_in.dart';
import 'package:pet_rescue_mobile/main.dart';

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
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.black,
              onPressed: () {
                confirmationDialog(
                    context, "Are you sure you want to sign out?",
                    positiveText: "Yes",
                    neutralText: "No",
                    confirm: false, positiveAction: () {
                  signOutGoogle().then((_) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  });
                });
              },
            )
          ],
        ),
        body: Center(
          child: Container(
              child: Column(
            children: [
              ProfilePic(),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
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
                  ],
                ),
              )
            ],
          )),
        ));
  }
}
